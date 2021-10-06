# HyperspectraWithNeXL

This code base is using the Julia Language and [DrWatson](https://juliadynamics.github.io/DrWatson.jl/stable/)
to make a reproducible scientific project named
> HyperspectraWithNeXL

HyperspectraWithNeXL provides the code and data discussed in the paper "Reproducible Spectral and Hyper-Spectral Analysis using NeXL"

The project is authored by Nicholas W. M. Ritchie.

To (locally) reproduce this project, do the following:

0. Download this code base. Notice that not all raw data is included in the git-history but will be automatically downloaded from the NIST MIDAS site upon first demand.
1. Open a Julia console and do:
   ```
   julia> using Pkg
   julia> Pkg.activate(raw"path/to/this/project")
   julia> Pkg.instantiate()
   ```
2. The script "scripts\build.jl" will generate the outputs presented in the paper and a handful of other demonstrative scripts.
   ```
   julia> cd(raw"path/to/this/project")
   julia> using DrWatson
   julia> @quickactivate "HyperspectraWithNeXL"
   julia> include(joinpath(scriptsdir(),"build.jl"))
   ```

Please direct any questions to nicholas.ritchie@nist.gov