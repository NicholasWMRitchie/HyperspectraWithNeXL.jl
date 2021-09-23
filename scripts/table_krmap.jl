using DrWatson
@quickactivate("HyperspectraWithNeXL")
# Load the necessary libraries
using HyperspectraWithNeXL
using NeXLSpectrum
using Gadfly, LinearAlgebra
using Images, FileIO, Unitful
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
# Build the fitting references
refpath = datadep"MnNodule_Standards"
refs = references( [
    reference(n"C", joinpath(refpath, "C std.msa") ),
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
    reference(n"Zn", joinpath(refpath, "Zn std.msa") ) ], 
    132.0
)
# Fit the reference spectra to the HyperSpectrum unknown
resf = fit_spectrum(hs, refs, mode = :Fast)
# Select the optimal k-ratio (K, L? or M?) for each element
bestks = optimizeks(SimpleKRatioOptimizer(2.0), resf)
# Convert compound k-ratios to pure element equivalents (matrix correction)
pureks = aspure.(bestks)
# Normalize the k-ratios at each point in the HyperSpectrum
bestf = LinearAlgebra.normalize(pureks)
# Display the resulting images
labeledimages([ "$(bf.xrays)" for bf in bestf],[Log3Band.(bf.kratios) 
                for bf in bestf ], ncols=4)
