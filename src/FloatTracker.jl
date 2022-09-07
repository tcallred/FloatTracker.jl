module FloatTracker

export TrackedFloat16, TrackedFloat32, TrackedFloat64, print_log, write_log_to_file
import Base

include("Event.jl")
include("Logger.jl")
include("TrackedFloat.jl")

end # module
