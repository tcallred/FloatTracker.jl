include("../../src/FloatTracker.jl")
using .FloatTracker: TrackedFloat64, write_log_to_file
using LinearAlgebra

# from Demmel section 2.4.1
# TODO find equivalent

A = [TrackedFloat64(1) TrackedFloat64(0);
     TrackedFloat64(NaN) TrackedFloat64(2)]

b = [TrackedFloat64(0), TrackedFloat64(1)]

ul = 'U' # 'U' = upper tri, 'L' = lower tri
tA = 'N' # transpose? N = no, T = yes, C = yes and conjugate
dA = 'U' # N = read, U = ignored

# UHOH what to do
println(LinearAlgebra.BLAS.trsv(ul, tA, dA, A, b))
#write_log_to_file()

