module HyperspectraWithNeXL

using DrWatson
using Reexport
using Downloads
@reexport using DataDeps

# Register hyperspectral data and standards
function __init__()
    (!isdir(datadir(),"exp_raw")) && mkdirs(datadir(),"exp_raw")
    ENV["DATADEPS_LOAD_PATH"] = mkpath(joinpath(datadir(),"exp_raw"))
    register(DataDep("MnNodule",
        """
        Dataset: Deep sea manganese nodule electron excited X-ray microanalysis hyperspectral data set
         Author: Nicholas W. M. Ritchie (NIST)
        License: Public Domain
        Website: https://data.nist.gov/od/id/mds2-2467
         Notice: This file is over 600 Mb
        """,
        "https://data.nist.gov/od/ds/mds2-2467/MnNodule.tar.gz",
        "5b5b6623b8f4daca3ff3073708442ac5702ff690aa12668659875ec5642b458d",
        post_fetch_method = unpack
    ))
    register(DataDep("MnNodule_Standards",
        """
        Dataset: Standard spectra for the deep sea manganese nodule electron excited X-ray microanalysis hyperspectral data set
         Author: Nicholas W. M. Ritchie (NIST)
        License: Public Domain
        Website: https://data.nist.gov/od/id/mds2-2467
        """,
        "https://data.nist.gov/od/ds/mds2-2467/MnNodule_Standards.tar.gz",
        "69283ba72146932ba451e679cf02fbd6b350f96f6d012d50f589ed9dd2e35f1a",
        post_fetch_method = unpack
    ))
end

# Nothing to export
include("tohdf5.jl")

end