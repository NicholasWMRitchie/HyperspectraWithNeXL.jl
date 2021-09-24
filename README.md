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
   julia> Pkg.activate("path/to/this/project")
   julia> Pkg.instantiate()
   ```

This will install all necessary packages for you to be able to run the scripts and
everything should work out of the box.
