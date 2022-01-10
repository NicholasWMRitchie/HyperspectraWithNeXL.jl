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
# Independent normalization (to brightest pixel)
FileIO.save(File{format"PNG"}(joinpath(plotsdir(),"ROI_I[Mn K-L3].png")), hs[n"Mn K-L3"])
FileIO.save(File{format"PNG"}(joinpath(plotsdir(),"ROI_I[Fe K-L3].png")), hs[n"Fe K-L3"])
FileIO.save(File{format"PNG"}(joinpath(plotsdir(),"ROI_I[O K-L3].png")), hs[n"O K-L3"])
# Normalized as a set (normalize to sum of intensities)
imgs = hs[ [n"Mn K-L3", n"Fe K-L3", n"O K-L3" ] ]
for (i, img) in enumerate(imgs)
  FileIO.save(File{format"PNG"}(joinpath(plotsdir(),"ROI[$i].png")), img)
end
# RGB 
img = hs[ n"Mn K-L3", n"Fe K-L3", n"O K-L3"]
FileIO.save(File{format"PNG"}(joinpath(plotsdir(),"ROI[Mn K-L3, Fe K-L3, O K-L3].png")), img)