include("../src/FloatTracker.jl")
using .FloatTracker: TrackedFloat64, write_log_to_file
using LinearAlgebra

# from Demmel section 2.4.1
# TODO find equivalent

A = [Float64(1) Float64(0);
     Float64(NaN) Float64(2)]

b = [Float64(0), Float64(1)]

ul = 'U' # 'U' = upper tri, 'L' = lower tri
tA = 'N' # transpose? N = no, T = yes, C = yes and conjugate
dA = 'U' # N = read, U = ignored

# UHOH what to do
#println(LinearAlgebra.BLAS.trsv(ul, tA, dA, A, b))
#write_log_to_file()

