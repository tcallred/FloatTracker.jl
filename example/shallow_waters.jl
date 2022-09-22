include("../src/FloatTracker.jl")
using .FloatTracker: TrackedFloat32, write_log_to_file, set_inject_nan
using ShallowWaters

# run_model()
run_model(TrackedFloat32)

