# BG TODO runs, but no events
# 2022-10-25 stackoverflow

#=
# Linear elasticity
=#

### If the Finch package has already been added, use this line #########
using Finch # Note: to add the package, first do: ]add "https://github.com/paralab/Finch.git"

include("../../src/FloatTracker.jl")
using .FloatTracker: write_log_to_file, set_inject_nan, set_logger, set_exclude_stacktrace
fns = []
set_inject_nan(true, 1, 1, fns)
set_logger("tf-elasticity", 5)
set_exclude_stacktrace([:prop])

### If not, use these four lines (working from the examples directory) ###
# if !@isdefined(Finch)
#     include("../Finch.jl");
#     using .Finch
# end
##########################################################################

init_finch("elasticity");

# Optionally generate a log
useLog("elasticitylog", level=3)

n = [20,4,4]; # number of elements in x,y,z
interval = [0,1,0,0.2,0,0.2]; # domain bounds

# Set up the configuration (order doesn't matter)
domain(3, grid=UNSTRUCTURED)
functionSpace(order=2)      # basis polynomial order

# Specify the problem
mesh(HEXMESH, elsperdim=n, bids=4, interval=interval)

u = variable("u", type=VECTOR)          # make a vector variable with symbol u
testSymbol("v", type=VECTOR)            # sets the symbol for a test function

boundary(u, 1, DIRICHLET, [0,0,0]) # x=0
boundary(u, 2, NEUMANN, [0,0,0])   # elsewhere
boundary(u, 3, NEUMANN, [0,0,0])
boundary(u, 4, NEUMANN, [0,0,0])

# Write the weak form
# coefficient("mu", "x>0.5 ? 0.2 : 10") # discontinuous mu
coefficient("mu", "TrackedFloat64(1)") # constant mu
coefficient("lambda", "TrackedFloat64(1.25)")
coefficient("f", [0,0,-10], type=VECTOR)
weakForm(u, "inner( (lambda * div(u) .* [1 0 0; 0 1 0; 0 0 1] + mu .* (grad(u) + transpose(grad(u)))), grad(v)) - dot(f,v)")
# [TrackedFloat64(1) TrackedFloat64(0) TrackedFloat64(0); TrackedFloat64(0) TrackedFloat64(1) TrackedFloat64(0); TrackedFloat64(0) TrackedFloat64(0) TrackedFloat64(1)]
# [1 0 0; 0 1 0; 0 0 1]

exportCode("elasticitycode")

println("solving")
t = @elapsed(solve(u));
println("solved")

println("time: "*string(t))
# Dump things to the log if desired
# log_dump_config();
# log_dump_prob();

# Write result to vtk file
#output_values(u, "elasticity", format="vtk");

finalize_finch() # Finish writing and close any files

println("u_z at end "*string(maximum(u.values[3,Finch.grid_data.bdry[2][3]])));

write_log_to_file()
