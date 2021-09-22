using DrWatson
@quickactivate("HyperspectraWithNeXL")
using NeXLSpectrum# Load the necessary libraries
using NeXLSpectrum
using Gadfly, DataFrames
# Load the unknown spectra from disk
specpath = normpath(joinpath(datadir(),"exp_raw","K2496"))
k2496 = loadspectrum.(joinpath(specpath,"K2496_$(i).msa") for i in 1:3)
# Construct and apply the detector to the unknown spectra 
det = matching(k2496[1], 132.0, 110, Dict(MShell=>n"Cs"))
k2496 = map(s->apply(s, det), k2496)
# Load the reference spectra and construct the filtered references
refs = references([
  reference(n"Si", joinpath(specpath, "Sanbornite std.msa"), mat"BaSi2O5"),
  reference(n"Ba", joinpath(specpath, "Sanbornite std.msa"), mat"BaSi2O5"),
  reference(n"Ba", joinpath(specpath, "BaCl2 std.msa"), mat"BaCl2"),
  reference(n"O", joinpath(specpath, "MgO std.msa"), mat"MgO"),
  reference(n"Ti", joinpath(specpath, "Ti std.msa"), mat"Ti") ], det)
# Fit the unknown spectra with the filtered references
fs=fit_spectrum(k2496, refs)
# Plot the raw spectrum and the residual
display(plot(fs[1]))
# Matrix correct the k-ratios and tabulate the results
q=quantify.(fs)
nom = parse(Material, "0.323*O+0.2291*Si+0.018*Ti+0.4299*Ba",name="Nominal")
asa(DataFrame, q, nominal=nom)