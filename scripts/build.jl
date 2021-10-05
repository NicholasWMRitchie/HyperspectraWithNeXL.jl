using DrWatson
@quickactivate "HyperspectraWithNeXL"
using Weave

using HyperspectraWithNeXL

ENV["DATADEPS_ALWAYS_ACCEPT "] = true
datadep"MnNodule"
datadep"MnNodule_Standards"

include("figure_maxpix.jl")
include("figure_roimaps.jl")
include("table_1.jl")
include("table_krmap.jl")

weave(joinpath(scriptsdir(), "quantify_k2496.jmd"), fig_ext=".svg")
weave(joinpath(scriptsdir(), "kratiomapMnNodule.jmd"), fig_ext=".svg")
weave(joinpath(scriptsdir(), "mapMnNodule.jmd"), fig_ext=".svg")
weave(joinpath(scriptsdir(), "processMnNodule.jmd"), fig_ext=".svg")
weave(joinpath(scriptsdir(), "quantifyMnNodule.jmd"), fig_ext=".svg")

notebookspath() = joinpath(projectdir(), "notebooks")

weave(joinpath(notebookspath(), "K2496_linearOfit.ipynb"), fig_ext=".svg")
weave(joinpath(notebookspath(), "quant.ipynb"), fig_ext=".svg")
weave(joinpath(notebookspath(), "quantifyK2496_Benitoite.ipynb"), fig_ext=".svg")
weave(joinpath(notebookspath(), "quantifyK2496_Benitoite_c.ipynb"), fig_ext=".svg")
weave(joinpath(notebookspath(), "quantifyK2496_stds_c.ipynb"), fig_ext=".svg")
weave(joinpath(notebookspath(), "quantifyK2496_stds.ipynb"), fig_ext=".svg")
weave(joinpath(notebookspath(), "quantifyK2496.ipynb"), fig_ext=".svg")
weave(joinpath(notebookspath(), "suitability.ipynb"), fig_ext=".svg")

