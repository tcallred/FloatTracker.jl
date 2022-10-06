include("../src/FloatTracker.jl")
using .FloatTracker: TrackedFloat64, FunctionRef, write_log_to_file, set_inject_nan
using LinearAlgebra
using SparseArrays
using IterativeSolvers

fns = [FunctionRef(:norm2, Symbol("generic.jl"), 524)]
set_inject_nan(true, 1, 1, fns)

A = sparse([TrackedFloat64(1), TrackedFloat64(1), TrackedFloat64(2), TrackedFloat64(3)], 
           [TrackedFloat64(1), TrackedFloat64(3), TrackedFloat64(2), TrackedFloat64(3)], 
           [TrackedFloat64(0), TrackedFloat64(1), TrackedFloat64(2), TrackedFloat64(0)]
        )

# B = [TrackedFloat64(1e-300), TrackedFloat64(3e-300), TrackedFloat64(1e-300)]
B = [TrackedFloat64(2), TrackedFloat64(5), TrackedFloat64(1.5)]


# A = sparse([1.0,1.0,2.0,3.0], 
#            [1.0,3.0,2.0,3.0], 
#            [0.0,1.0,2.0,0.0]
#         )
#
# B = [1.0,3.0,2.0]

println(IterativeSolvers.cg(A, B))
write_log_to_file(file_name="cg")
