using HDF5: attributes, create_group, h5open
using HDF5: File as h5file
using NeXLCore

"""
   Base.write(h5::HDF5.File, path::AbstractString, mats::AbstractArray{<:Material})

Write an AbstractArray{<:Material} to an HDF5 file.
"""
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


"""
   Base.read(h5::HDF5.File, path::AbstractString, ::Type{Material})

Read an AbstractArray{<:Material} from an HDF5 file.
"""
function Base.read(h5::h5file, path::AbstractString, ::Type{Material})
    @assert haskey(h5, path)
    g = h5[path]
    els = map(el->parse(Element,el), read(attributes(g)["elements"]))
    tmp = g["massfractions"]
    data = zeros(eltype(tmp), size(tmp)...)
    copy!(data, tmp[axes(tmp)...])
    tmp = nothing
    @assert length(els) == size(data,1) "The number of elements must match the depth of the mass-fractions data."
    return map(CartesianIndices(size(data)[2:end])) do ci
        m = data[:, ci]
        material("M$(ci.I)", Dict(els[i] => m[i] for i in filter(j -> m[j] > 0, eachindex(m))))
    end
end

