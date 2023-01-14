include("../src/FloatTracker.jl")
using .FloatTracker: TrackedFloat16, TrackedFloat32, write_log_to_file, set_inject_nan, set_exclude_stacktrace, set_logger
using ShallowWaters

# run_model()
# run_model(TrackedFloat32)
set_logger(filename="sh", buffersize=20, cstg=true, cstgArgs=false, cstgLineNum=false)
set_exclude_stacktrace([:prop])
P = run_model(T=TrackedFloat32, Tprog=TrackedFloat32, Tcomm=TrackedFloat32, Tini=TrackedFloat16,Ndays=100,nx=100,L_ratio=0.5,bc="nonperiodic",wind_forcing_x="double_gyre",topography="seamount", scale_sst=2^18, time_scheme="RK", output=1, cfl=20 );
write_out_logs()
