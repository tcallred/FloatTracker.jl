include("../src/FloatTracker.jl")
using .FloatTracker: TrackedFloat16

function maximum(lst)
  curr_max = 0.0
  for x in lst
    if curr_max < x 
      curr_max = x
    end
  end
  curr_max
end

function maximum2(lst)
  foldl(max, lst)
end
  
println("--- With less than ---")
res = maximum([TrackedFloat16(x) for x in [1, NaN, 4]])
println("Result: $(res.val)")
println("Journey: $(res.journey)")
println()

println("--- With builtin max ---")
res2 = maximum2([TrackedFloat16(x) for x in [1, NaN, 4]])
println("Result: $(res2.val)")
println("Journey: $(res2.journey)")
