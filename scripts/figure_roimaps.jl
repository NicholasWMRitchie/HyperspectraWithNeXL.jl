using DrWatson
@quickactivate("HyperspectraWithNeXL")
# Load the necessary libraries
using HyperspectraWithNeXL
using NeXLSpectrum
using Unitful
using FileIO, ImageIO

# Load the HyperSpectrum from disk
lt = 0.72*4.0*18.0*3600.0/(1024*1024) # 18.0 hours on 4 detectors
hs = NeXLSpectrum.compress(HyperSpectrum(
    LinearEnergyScale(0.0,10.0),
    Dict{Symbol,Any}(
      :TakeOffAngle => deg2rad(35.0),
      :ProbeCurrent => 1.0, 
      :LiveTime => lt, 
      :BeamEnergy => 20.0e3, 
      :Name => "Mn Nodule"
    ),
    readrplraw(joinpath(datadep"MnNodule","map[15]")), 
    fov = [ 4.096u"mm", 4.096u"mm"], offset= [ 0.0u"mm", 0.0u"mm" ]
))
outpath = joinpath(papersdir(),"Figures","Figure 5")
mkpath(outpath)
cp(joinpath(datadep"MnNodule","Image[0][[1]].png"), joinpath(outpath,"Mn_nodule_BSED.png"), force=true)

# Independent normalization (to brightest pixel)
outpath = joinpath(papersdir(),"Figures","Figure 6")
mkpath(outpath)
FileIO.save(File{format"PNG"}(joinpath(outpath,"I[C K-L2].png")), hs[n"Mn K-L3"])
FileIO.save(File{format"PNG"}(joinpath(outpath,"I[Mn K-L3].png")), hs[n"Mn K-L3"])
FileIO.save(File{format"PNG"}(joinpath(outpath,"I[Fe K-L3].png")), hs[n"Fe K-L3"])
FileIO.save(File{format"PNG"}(joinpath(outpath,"I[O K-L3].png")), hs[n"O K-L3"])
# Normalized as a set (normalize to sum of intensities)

outpath=plotsdir()
mkpath(outpath)
cxrs = [n"Mn K-L3", n"O K-L3", n"Fe K-L3" ]
imgs = hs[ cxrs ]
for (cxr, img) in zip(cxrs, imgs)
  FileIO.save(File{format"PNG"}(joinpath(outpath,"I_rel[$cxr].png")), img)
end
# RGB 
outpath = joinpath(papersdir(),"Figures","Figure 7")
mkpath(outpath)
img = colorize(hs, cxrs, :All)
FileIO.save(File{format"PNG"}(joinpath(outpath,"colorized[Mn,O,Fe,All].png")), img)
img = colorize(hs, cxrs, :Each)
FileIO.save(File{format"PNG"}(joinpath(outpath,"colorized[Mn,O,Fe,Each].png")), img)