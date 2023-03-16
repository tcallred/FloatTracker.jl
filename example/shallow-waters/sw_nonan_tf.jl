include("../../src/FloatTracker.jl")
using .FloatTracker: TrackedFloat16, TrackedFloat32, write_out_logs, set_inject_nan, set_exclude_stacktrace, set_logger
using ShallowWaters, PyPlot

set_logger(filename="nonan_tf", buffersize=20, cstg=true, cstgArgs=false, cstgLineNum=false)
set_exclude_stacktrace([:prop])

P = run_model(T=TrackedFloat32, Ndays=100,nx=100,L_ratio=1,bc="nonperiodic",wind_forcing_x="double_gyre",topography="seamount")
pcolormesh(P.η')
savefig("height_nonan_tf.png")

speed = sqrt.(Ix(P.u.^2)[:,2:end-1] + Iy(P.v.^2)[2:end-1,:])
pcolormesh(speed')
savefig("speed_nonan_tf.png")

write_out_logs()
