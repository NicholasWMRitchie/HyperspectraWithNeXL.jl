using DrWatson
@quickactivate("HyperspectraWithNeXL")
# Load the necessary libraries
using HyperspectraWithNeXL
using NeXLSpectrum
using Gadfly # , Cairo, Fontconfig, 
using Unitful
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
klms = [ 
    n"C K-L2", #
    characteristic(n"Ag", ltransitions, 0.1)..., #
    n"Al K-L3", #
    n"Ca K-L3", n"Ca K-M3", #
    n"Ce L3-M5", # 
    n"Cl K-L3", #
    n"Cr K-L3", n"Cr K-M3", n"Cr L3-M5", #
    n"Cu K-L3", n"Cu K-M3", n"Cu L3-M5", #
    n"Fe K-L3", n"Fe K-M3", n"Fe L3-M5", #
    n"S K-L3", n"S K-M3", #
    characteristic(n"Ba", ltransitions, 0.03)..., #
    n"P K-L3", #
    n"K K-L3", #
    n"Mg K-L3", #
    n"O K-L3", #
    n"Mn K-L3", n"Mn K-M3", n"Mn L3-M5", #
    n"Na K-L3", #
    n"Ni K-L3", n"Ni K-M3", n"Ni L3-M5", #
    n"Si K-L3", #
    n"Ti K-L3", n"Ti K-M3", n"Ti L3-M4", #
    n"Zn K-L3", n"Zn K-M3", n"Zn L3-M5", #
]
set_default_plot_size(8inch, 3inch)
p1 = vstack(
    plot(maxpixel(hs), klms=klms, xmax=10.0e3),
    plot(sum(hs), klms=klms, xmax=10.0e3)
) 
# p1 |> PDF(joinpath(plotsdir(),"MaxPixel.pdf"), 6inch, 4inch)
p1 |> SVG(joinpath(plotsdir(), "MaxPixel.svg"), 6inch, 4inch)

p2=plot(maxpixel(hs), sum(hs), klms=klms, xmax=10.0e3, norm=ScaleSum()) 
# p2 |> PDF(joinpath(plotsdir(),"MaxPixel2.pdf"), 8inch, 3inch)
p2 |> SVG(joinpath(plotsdir(), "MaxPixel2.svg"), 6inch, 4inch)

mkpath(joinpath(papersdir(),"Figures", "Figure 2"))
p3=plot(maxpixel(hs), klms=klms, xmax=10.0e3) 
p3 |> SVG(joinpath(papersdir(),"Figures", "Figure 2","maxpixel.svg"), 8inch, 3inch)
