include("../src/FloatTracker.jl")
using .FloatTracker

a = FloatTracker.TrackedFloat16.(3.0)
b = FloatTracker.TrackedFloat16.(NaN)

a + b

c = FloatTracker.TrackedFloat16.(0.0)
d = FloatTracker.TrackedFloat16.(0.0)

c / d

a < b

-b
abs(b)
