using DrWatson
@quickactivate "HyperspectraWithNeXL"

using NeXLSpectrum
using Gadfly

fes=loadspectrum(joinpath(datadir(),"exp_raw","FeS_and_FeS2","FeS std.msa"))
fes2=loadspectrum(joinpath(datadir(),"exp_raw","FeS_and_FeS2","FeS2 std.msa"))

set_default_plot_size(10inch,3inch)
p = plot(fes, fes2, klms=[n"Fe K-L3", n"Fe K-M3", n"Fe L3-M5", n"Fe L2-M1", n"S K-L3", n"S K-M3"], xmax=10.0e3)
mkpath(joinpath(papersdir(),"Figures", "Figure 1"))
p |> SVG(joinpath(papersdir(),"Figures", "Figure 1","FeS vs FeS2.svg"), 10inch, 3inch)