module FloatTracker

export TrackedFloat16, TrackedFloat32, TrackedFloat64, FunctionRef, print_log, write_log_to_file, set_inject_nan
import Base

include("Event.jl")
include("Logger.jl")
include("Injector.jl")
include("TrackedFloat.jl")

end # module
