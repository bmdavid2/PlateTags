module PlateTags

using DataFrames,PDFmerger,UUIDs,Plots,QRCoders

import Plots: plot 

include("types.jl")
include("plotting.jl")

export PlateTag, MicroTag, CryoTag, BottleTag 
export plot 

end # module PlateTags
