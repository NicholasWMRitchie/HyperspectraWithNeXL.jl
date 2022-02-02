using DrWatson
@quickactivate "HyperspectraWithNeXL"
using Weave

using HyperspectraWithNeXL

ENV["DATADEPS_ALWAYS_ACCEPT"] = true
@warn """
    This script will download necessary data from a NIST file server the first time it is required.
    This download is over 500 MB and will require an active Internet connection.
    The data will be placed in the `joinpath(datadir(), "exp_raw") folder.  Outputs from the scripts
    are placed in `plotsdir()`, `papersdir()` and intermediate files are placed in 
    `joinpath(datadir(),"exp_pro")`
    """

# To process individual files, set `doit=false` and comment `doit &&` out of the line you wish to process.
doit=true

mkpath(joinpath(papersdir(),"Figures"))
mkpath(joinpath(papersdir(),"Tables"))
mkpath(plotsdir())
mkpath(joinpath(datadir(),"exp_pro"))

doit && include("table_k2496_quant.jl")
doit && include("figure_maxpix.jl")
doit && include("figure_roimaps.jl")
doit && include("table_krmap.jl")
doit && include("fes_fes2_figure.jl")

doit && weave(joinpath(scriptsdir(), "quantify_k2496.jmd"), fig_ext=".svg")
doit && weave(joinpath(scriptsdir(), "kratiomapMnNodule.jmd"), fig_ext=".svg")
doit && weave(joinpath(scriptsdir(), "mapMnNodule.jmd"), fig_ext=".svg")
doit && weave(joinpath(scriptsdir(), "processMnNodule.jmd"), fig_ext=".svg")

notebookspath() = joinpath(projectdir(), "notebooks")

doit && weave(joinpath(notebookspath(), "K2496_linearOfit.ipynb"), fig_ext=".svg")
doit && weave(joinpath(notebookspath(), "quant.ipynb"), fig_ext=".svg")
doit && weave(joinpath(notebookspath(), "quantifyK2496_Benitoite.ipynb"), fig_ext=".svg")
doit && weave(joinpath(notebookspath(), "quantifyK2496_Benitoite_c.ipynb"), fig_ext=".svg")
doit && weave(joinpath(notebookspath(), "quantifyK2496_stds_c.ipynb"), fig_ext=".svg")
doit && weave(joinpath(notebookspath(), "quantifyK2496_stds.ipynb"), fig_ext=".svg")
doit && weave(joinpath(notebookspath(), "quantifyK2496.ipynb"), fig_ext=".svg")
doit && weave(joinpath(notebookspath(), "suitability.ipynb"), fig_ext=".svg")

# Do a little cleanup before the main show!
GC.gc(true)
doit && weave(joinpath(scriptsdir(), "quantifyMnNodule.jmd"), fig_ext=".svg")

using NeXLSpectrum: kill_weave_temporaries
kill_weave_temporaries(scriptsdir())
kill_weave_temporaries(notebookspath())