# HyperspectraWithNeXL.jl
### Processing hyperspectral data in Julia using the NeXL toolkit

This code base is using the Julia Language and [DrWatson](https://juliadynamics.github.io/DrWatson.jl/stable/)
to make a reproducible scientific project named `HyperspectraWithNeXL.jl`.

`HyperspectraWithNeXL.jl` provides the code and data discussed in the paper "Reproducible Spectrum and Hyperspectrum Data Analysis using NeXL" by Nicholas W. M. Ritchie accepted for publication in the Microsopy and Microanalysis journal (https://www.cambridge.org/core/journals/microscopy-and-microanalysis) in 2022.

The project is authored and the data was collected by Nicholas W. M. Ritchie.

To (locally) reproduce this project, do the following:

0. Download and install "Julia 1.7.1" from [Julia downloads](https://julialang.org/downloads/).  [Direct link for 64-bit Windows](https://julialang-s3.julialang.org/bin/winnt/x64/1.7/julia-1.7.1-win64.exe) 1.7.1 is also available for other platforms via [this JSON file](https://julialang-s3.julialang.org/bin/versions.json).  The project assumes this version to ensure reproducibility.  Later versions of Julia may work with minor modifications to account for the difference.
1. Download this code base and place it in a path on a fast, local disk. We'll assume this location is `path/to/HyperspectraWithNeXL.jl`. Notice that not all raw data is included in the git-history.  Some data will be automatically downloaded from the NIST MIDAS site upon first demand.
2. Open a Julia console and perform these commands:
   ```
   julia> using Pkg
   julia> Pkg.activate(raw"path/HyperspectraWithNeXL.jl")
   julia> Pkg.instantiate()
   ```
   This will download all the necessary library dependencies and precompile them.  It will take a few minutes.
   
3. The script "scripts\build.jl" will generate the outputs presented in the paper and a handful of other demonstrative scripts.  The script is quite memory and CPU intensive and is known to fail on Windows computers with 16 GB of RAM.  It has been tested successfully on i7 Windows 10 computers with 32 GB and 64 GB.  The script will take hours to run.  The most time intensive part is the full fit and quantification of a 1024 pixel x 1024 pixel spectrum image which is the final step in the build.
   ```
   julia> include(joinpath("path","to","HyperspectraWithNeXL.jl","scripts","build.jl"))
   ```
   
   The script will download the hyperspectral data from a NIST-hosted website as necessary. The data is downloaded only once but is over 500 MB.  The data is downloaded to the "data/exp_raw" directory and consists of a RPL/RAW file pair, a pair of secondary and backscatter images and the necessary elemental standard spectra.

   Once the script has run, the outputs are found in the "data/exp_pro", "plots", "scripts", "notebooks" and "papers" directories.  The script builds a number of HTML documents, creates a number of PNG bitmap images, a number of scalable SVG vector images, and some intermediate files.  The journal article figures are found in the "paper/Figures" directory.

Please direct any questions to nicholas.ritchie@nist.gov
