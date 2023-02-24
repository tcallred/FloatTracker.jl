include("../src/FloatTracker.jl")
using .FloatTracker: TrackedFloat16, TrackedFloat32, write_log_to_file, set_inject_nan, set_exclude_stacktrace, set_logger

set_logger(filename="sh", buffersize=20, cstg=true, cstgArgs=false, cstgLineNum=false)
set_exclude_stacktrace([:prop])

using NBodySimulator
using StaticArrays
using Plots
body1 = MassBody(SVector(TrackedFloat64(0.0), TrackedFloat64(1.0), TrackedFloat64(0.0)), SVector(TrackedFloat64(5.775e-6), TrackedFloat64(0.0), TrackedFloat64(0.0)), TrackedFloat64(2.0))
body2 = MassBody(SVector(TrackedFloat64(0.0), TrackedFloat64(-1.0), TrackedFloat64(0.0)), SVector(TrackedFloat64(-5.775e-6), TrackedFloat64(0.0), TrackedFloat64(0.0)), TrackedFloat64(2.0))
G = 6.673e-11
system = GravitationalSystem([body1, body2], G)
tspan = (TrackedFloat64(0.0), TrackedFloat64(1111150.0))
simulation = NBodySimulation(system, tspan)
sim_result = run_simulation(simulation)
animate(sim_result, "animated_particles.gif")
