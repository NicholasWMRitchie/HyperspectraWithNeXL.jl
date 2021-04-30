#using Revise
using NeXLSpectrum

path = @__DIR__

lt = 0.70*4.0*18.0*3600.0/(1024*1024) # 18.0 hours on 4 detectors
hs = NeXLSpectrum.compress(HyperSpectrum(
    LinearEnergyScale(0.0,10.0),
    Dict{Symbol,Any}(:ProbeCurrent => 1.0, :LiveTime => lt, :BeamEnergy => 20.0e3, :Name => splitdir(path)[2], :TakeOffAngle => deg2rad(35.0)),
    readrplraw(joinpath(path,"map[15]")),
    fov = ( 4.096, 4.096 )
));

refpath = joinpath(path, "Standards")

refs = references( [
    reference(n"Ag", joinpath(refpath, "Ag std.msa") ),
    reference(n"Al", joinpath(refpath, "Al std.msa") ),
    reference(n"C", joinpath(refpath, "C std.msa") ),
    reference(n"Ca", joinpath(refpath, "CaF2 std.msa") ),
    reference(n"Ba", joinpath(refpath, "BaF2 std.msa") ),
    reference(n"Cr", joinpath(refpath, "Cr std.msa") ),
    reference(n"Cu", joinpath(refpath, "Cu std.msa") ),
    reference(n"Fe", joinpath(refpath, "Fe std.msa") ),
    reference(n"S", joinpath(refpath, "FeS2 std.msa") ),
    reference(n"P", joinpath(refpath, "GaP std.msa") ),
    reference(n"K", joinpath(refpath, "KBr std.msa") ),
    reference(n"Mg", joinpath(refpath, "Mg std.msa") ),
    reference(n"O", joinpath(refpath, "MgO std.msa") ),
    reference(n"Mn", joinpath(refpath, "Mn std.msa") ),
    reference(n"Na", joinpath(refpath, "NaCl std.msa") ),
    reference(n"Ni", joinpath(refpath, "Ni std.msa") ),
    reference(n"Si", joinpath(refpath, "Si std.msa") ),
    reference(n"Ti", joinpath(refpath, "Ti std.msa") ),
    reference(n"Zn", joinpath(refpath, "Zn std.msa") ) ], 132.0
)

using ThreadsX
using ProgressMeter
using Colors
using FileIO
using Profile, ProfileSVG
using Images

extract(res, elm) = map(mat->mat[elm], res)
toyellow(rgb) = isNaN(rgb.r) ? RGB(1.0,1.0,0.0) : rgb
toblack(mat) = analyticaltotal(mat)<0.5 ? NeXLCore.NULL_MATERIAL : mat
if true
    #roc = 508:515
    roc = 1:1024
    resf =  fit_spectrum(hs[roc,roc], refs, mode = :Fast)
    #resf = fit_spectrum(hs, refs, mode = :Fast)
    res = @time quantify(resf, mapfunc=ThreadsX.map)
    resn = asnormalized.(toblack.(res))
    for elm in elms(refs)
        elmq = extract(resn, elm)
        FileIO.save("Quant[$(symbol(elm))][Linear].png", gray.(elmq))
        FileIO.save("Quant[$(symbol(elm))][Log3band].png", Log3Band.(elmq))
    end
    FileIO.save("Colorized[Red=Mn,Green=C,Blue=O].png", colorview(RGB, extract(resn,n"Mn"), extract(resn,n"C"), extract(resn,n"O")))
else
    roc = 508:515
    resf = fit_spectrum(hs[roc,roc], refs, mode = :Fast)
    res = quantify(resf, mapfunc=progress_map)

    Profile.init(n = 10^7)
    res= @profile quantify(resf)

    open("prof.txt", "w") do s
        Profile.print(IOContext(s, :displaysize => (24, 500)), format=:flat)
    end
    ProfileSVG.save("profile.svg")
end    