include("../src/FloatTracker.jl")
using .FloatTracker: TrackedFloat64, write_out_logs, set_logger

set_logger(filename="max", buffersize=1)

# Example from
#   DeepStability: A Study of Unstable Numerical Methods and Their
#   Solutions in Deep Learning
#   ICSE 2022
#   https://dl.acm.org/doi/10.1145/3510003.3510095
#
# softmax is a common "last layer" in deep neural networks
#  it converts value functions into action probabilities
# A straightforward implementation (unstable) gives NaNs for small inputs
#  because it makes huge exponents.
# A better implementation (stable) rescales before taking exponents,
#  but still overflows for large inputs.

function TF(arr)
  return map(x -> TrackedFloat64(x), arr)
end

function softmax_unstable(x)
  sum = 0
  result = similar(x)
  for i in length(x)
    sum += exp(x[i])
  end
  for j in length(x)
    result[j] = exp(x[j]) / sum
  end
  return result
end

function softmax_stable(x)
  sum = 0
  result = similar(x)
  max = maximum(x)
  for i in length(x)
    sum += exp(x[i] - max)
  end
  for j in length(x)
    result[j] = exp(x[j] - max) / sum
  end
  return result
end

input1 = TF([10.0, 100.0, 1000.0])
input2 = TF([-1000.0, -10000.0, -1000000.0])

println("--- unstable ---")
println("input1: $(softmax_unstable(input1))")
println("input2: $(softmax_unstable(input2))")

println()

println("--- stable ---")
println("input1: $(softmax_stable(input1))")
println("input2: $(softmax_stable(input2))")

