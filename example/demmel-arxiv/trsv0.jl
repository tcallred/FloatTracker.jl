include("../src/FloatTracker.jl")
using .FloatTracker: TrackedFloat64, write_log_to_file
using LinearAlgebra

# from Demmel section 2.3.3

A = [Float64(1) Float64(NaN);
     Float64(0) Float64(NaN)]

b = [Float64(1), Float64(0)]

ul = 'U' # 'U' = upper tri, 'L' = lower tri
tA = 'N' # transpose? N = no, T = yes, C = yes and conjugate
dA = 'U' # N = read, U = ignored

println(LinearAlgebra.BLAS.trsv(ul, tA, dA, A, b))
write_log_to_file()

# Juila gets it right with [NaN, NaN]

