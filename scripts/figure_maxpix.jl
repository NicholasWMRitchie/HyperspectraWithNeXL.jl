using DrWatson
@quickactivate("HyperspectraWithNeXL")
# Load the necessary libraries
using NeXLSpectrum
using Gadfly, Cairo, Fontconfig
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
klms = [ 
    n"C", n"Ag", n"Al", n"Ca", n"Ce", n"Cl", n"Cr", n"Cu", n"Fe", n"S", 
    n"P", n"K", n"Mg", n"O", n"Mn", n"Na", n"Ni", n"Si", n"Ti", n"Zn" 
]
vstack(
    plot(maxpixel(hs), klms=klms, xmax=10.0e3),
    plot(sum(hs), klms=klms, xmax=10.0e3)
) |> PDF(joinpath(plotsdir(),"MaxPixel.pdf"), 6inch, 4inch)

plot(maxpixel(hs), sum(hs), klms=klms, xmax=10.0e3, norm=ScaleSum()) |> 
    PDF(joinpath(plotsdir(),"MaxPixel2.pdf"), 8inch, 3inch)
