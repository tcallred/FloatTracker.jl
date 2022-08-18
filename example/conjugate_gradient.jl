include("../src/FloatTracker.jl")
using .FloatTracker: TrackedFloat64
using LinearAlgebra
using SparseArrays
using IterativeSolvers

A = sparse([TrackedFloat64(1), TrackedFloat64(1), TrackedFloat64(2), TrackedFloat64(3)], 
           [TrackedFloat64(1), TrackedFloat64(3), TrackedFloat64(2), TrackedFloat64(3)], 
           [TrackedFloat64(0), TrackedFloat64(1), TrackedFloat64(2), TrackedFloat64(0)]
        )

B = [TrackedFloat64(1), TrackedFloat64(3), TrackedFloat64(2)]


# A = sparse([1.0,1.0,2.0,3.0], 
#            [1.0,3.0,2.0,3.0], 
#            [0.0,1.0,2.0,0.0]
#         )
#
# B = [1.0,3.0,2.0]

println(IterativeSolvers.cg(A, B))
