# bg TODO runs but no events

#=
# 2D heat equation, Dirichlet bc, CG
=#

### If the Finch package has already been added, use this line #########
using Finch # Note: to add the package, first do: ]add "https://github.com/paralab/Finch.git"

include("../../src/FloatTracker.jl")
using .FloatTracker: write_log_to_file, set_inject_nan, set_logger, set_exclude_stacktrace
fns = []
set_inject_nan(true, 1, 1, fns)
set_logger("tf-heat2d", 5)
set_exclude_stacktrace([:prop])

### If not, use these four lines (working from the examples directory) ###
# if !@isdefined(Finch)
#     include("../Finch.jl");
#     using .Finch
# end
##########################################################################

init_finch("heat2d");

useLog("heat2dlog")

# Set up the configuration
domain(2)                   # dimension
functionSpace(order=2)      # basis polynomial order
timeStepper(RK4)            # time stepper (optional second arg is CFL#)

# Specify the problem
mesh(QUADMESH, elsperdim=10) # 10x10 elements

u = variable("u")            # make a scalar variable with symbol u
testSymbol("v")              # sets the symbol for a test function

T = 1;
timeInterval(T)              # The time interval is 0 to T
initial(u, "abs(x-0.5)+abs(y-0.5) < 0.2 ? 1 : 0") # initial condition

boundary(u, 1, DIRICHLET, 0)  # boundary condition for BID 1 is Dirichlet with value 0

# Write the weak form
coefficient("f", "TrackedFloat64(0.5*sin(6*pi*x)*sin(6*pi*y))")
weakForm(u, "Dt(u*v) + 0.01 * dot(grad(u),grad(v)) - f*v")

solve(u);

## Uncomment below to plot ##
# # solution is stored in the variable's "values"
# using Plots
# pyplot();
# display(plot(Finch.grid_data.allnodes[1,:], Finch.grid_data.allnodes[2,:], u.values[:], st = :surface))

finalize_finch() # Finish writing and close any files
write_log_to_file()
