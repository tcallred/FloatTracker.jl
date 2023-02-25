include("../src/FloatTracker.jl")
using .FloatTracker: TrackedFloat64, write_log_to_file, set_inject_nan, set_exclude_stacktrace, set_logger

set_logger(filename="nbody_stuffs", buffersize=20, cstg=true, cstgArgs=false, cstgLineNum=false)
set_exclude_stacktrace([:prop])

using NBodySimulator: NullThermostat, MassBody, InfiniteBox, GravitationalSystem, NBodySimulation, run_simulation
using StaticArrays
using Plots

# body1 = MassBody(SVector(0.0, 1.0, 0.0), SVector(5.775e-6, 0.0, 0.0), 2.0)
# body2 = MassBody(SVector(0.0, -1.0, 0.0), SVector(-5.775e-6, 0.0, 0.0), 2.0)

body1 = MassBody(SVector(TrackedFloat64(0.0), TrackedFloat64(1.0), TrackedFloat64(0.0)), SVector(TrackedFloat64(5.775e-6), TrackedFloat64(0.0), TrackedFloat64(0.0)), TrackedFloat64(2.0))
body2 = MassBody(SVector(TrackedFloat64(0.0), TrackedFloat64(-1.0), TrackedFloat64(0.0)), SVector(TrackedFloat64(-5.775e-6), TrackedFloat64(0.0), TrackedFloat64(0.0)), TrackedFloat64(2.0))

G = 6.673e-11
system = GravitationalSystem([body1, body2], G)

# tspan = (0.0, 1111150.0)

tspan = (TrackedFloat64(0.0), TrackedFloat64(1111150.0))

simulation = NBodySimulation(system, tspan, InfiniteBox(SVector(TrackedFloat64(-Inf), TrackedFloat64(Inf), TrackedFloat64(-Inf), TrackedFloat64(Inf), TrackedFloat64(-Inf), TrackedFloat64(Inf))),
                             NullThermostat(), TrackedFloat64(1.38e-23), x -> 0, x -> 0, x -> 0) # the 1.38e-23 is the kb_SI var; units: J/K
sim_result = run_simulation(simulation)
# animate(sim_result, "animated_particles.gif")
