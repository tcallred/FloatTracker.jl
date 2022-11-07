include("../src/FloatTracker.jl")
using .FloatTracker: TrackedFloat16, write_log_to_file, set_inject_nan, set_logger, set_exclude_stacktrace

set_logger("max", 5)
set_exclude_stacktrace([:prop])

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
# res = maximum([1, NaN, 4])
res = maximum([TrackedFloat16(x) for x in [1, NaN, 4]]).val
println("Result: $(res)")
println()

println("--- With builtin max ---")
# res2 = maximum2([1, NaN, 4])
res2 = maximum2([TrackedFloat16(x) for x in [1, NaN, 4]]).val
println("Result: $(res2)")

write_log_to_file()
