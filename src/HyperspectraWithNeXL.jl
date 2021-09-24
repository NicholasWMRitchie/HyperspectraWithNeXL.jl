module HyperspectraWithNeXL

using DrWatson
using Reexport
using Downloads
@reexport using DataDeps

# The NIST MIDAS site fails with the default HTTP.Downloads fetch function
custom_fetch(remote_filepath, local_directory) = 
    Downloads.download(remote_filepath, joinpath(local_directory, splitpath(remote_filepath)[end]))


# Register hyperspectral data and standards
function __init__()
    ENV["DATADEPS_LOAD_PATH"] = mkpath(joinpath(datadir(),"exp_raw"))
    register(DataDep("MnNodule",
        """
        Dataset: Deep sea manganese nodule electron excited X-ray microanalysis hyperspectral data set
         Author: Nicholas W. M. Ritchie (NIST)
        License: Public Domain
        Website: https://datapub.nist.gov/od/id/mds2-2467
         Notice: This file is over 600 Mb
        """,
        "https://datapub.nist.gov/midas//mds2-2467/MnNodule.tar.gz",
        "5b5b6623b8f4daca3ff3073708442ac5702ff690aa12668659875ec5642b458d",
        fetch_method = custom_fetch,
        post_fetch_method = unpack
    ))
    register(DataDep("MnNodule_Standards",
        """
        Dataset: Standard spectra for the deep sea manganese nodule electron excited X-ray microanalysis hyperspectral data set
         Author: Nicholas W. M. Ritchie (NIST)
        License: Public Domain
        Website: https://datapub.nist.gov/od/id/mds2-2467
        """,
        "https://datapub.nist.gov/midas//mds2-2467/MnNodule_Standards.tar.gz",
        "69283ba72146932ba451e679cf02fbd6b350f96f6d012d50f589ed9dd2e35f1a",
        fetch_method = custom_fetch,
        post_fetch_method = unpack
    ))
end

# Nothing to export
include("tohdf5.jl")

end