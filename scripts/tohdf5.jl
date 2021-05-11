
using HDF5: attributes, create_group, h5open
using HDF5: File as h5file

function Base.write(h5::h5file, path::AbstractString, mats::AbstractArray{<:Material})
    els=sort(collect(mapreduce(m->keys(m), union, mats)))
    data = zeros(Float64, length(els), size(mats)...)
    for (i, el) in enumerate(els), ci in CartesianIndices(mats)
        data[i, ci] = NeXLUncertainties.value(mats[ci][el])
    end
    g = create_group(h5, path)
    attributes(g)["elements"] = map(el->symbol(el), els)
    g["massfractions", compress=3] = data
    mats
end


function Base.read(h5::h5file, path::AbstractString, ::Type{Material})
    if haskey(h5, path)
        g = h5[path]
        els = map(el->parse(Element,el), read(attributes(g)["elements"]))
        data = g["massfractions"]
        return map(CartesianIndices(size(data)[2:end])) do ci
            massfracs = Dict(els[i] => data[i,ci] for i in 1:size(data,1))
            material("M$(ci.I)", filter(p->p.second>0.0, massfracs))
        end
    end
    return nothing
end

