using DrWatson
@quickactivate("HyperspectraWithNeXL")

using NeXLSpectrum
using Profile

path = joinpath(datadir(),"exp_raw","Mn Nodule")

lt = 0.72*4.0*18.0*3600.0/(1024*1024) # 18.0 hours on 4 detectors
hs = NeXLSpectrum.compress(HyperSpectrum(
    LinearEnergyScale(0.0,10.0),
    Dict{Symbol,Any}(
      :TakeOffAngle => deg2rad(35.0),
      :ProbeCurrent => 1.0, 
      :LiveTime => lt, 
      :BeamEnergy => 20.0e3, 
      :Name => splitdir(path)[2]),
    readrplraw(joinpath(path,"map[15]"))
))
hs[:Detector] = matching(hs, 132.0)

hs = hs[1:16:1024,1:16:1024]

refpath = joinpath(path, "Standards")
refs = references( [
    reference(n"Ag", joinpath(refpath, "Ag std.msa") ),
    reference(n"Al", joinpath(refpath, "Al std.msa") ),
    reference(n"C", joinpath(refpath, "C std.msa") ),
    reference(n"Ca", joinpath(refpath, "CaF2 std.msa") ),
    reference(n"Ce", joinpath(refpath, "CeO2 std.msa") ),
    reference(n"Cl", joinpath(refpath, "NaCl std.msa") ),
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

@time fit_spectrum(hs, refs, mode = :Full)

resf = @profview fit_spectrum(hs, refs, mode = :Full)