using DrWatson
@quickactivate("HyperspectraWithNeXL")
# Load the necessary libraries
using NeXLSpectrum
# Load the HyperSpectrum from disk
lt = 0.72*4.0*18.0*3600.0/(1024*1024) # 18.0 hours on 4 detectors
hs = NeXLSpectrum.compress(HyperSpectrum(
    LinearEnergyScale(0.0,10.0),
    Dict{Symbol,Any}(
      :TakeOffAngle => deg2rad(35.0),
      :ProbeCurrent => 1.0, 
      :LiveTime => lt, 
      :BeamEnergy => 20.0e3, 
      :Name => splitdir(path)[2]),
    readrplraw(joinpath(datadir(),"exp_raw","Mn Nodule","map[15]"))
))
display(hs[n"Mn K-L3"])
display.(hs[ [n"Mn K-L3", n"Fe K-L3", n"O K-L3" ] ])
display(hs[ n"Mn K-L3", n"Fe K-L3", n"O K-L3"])