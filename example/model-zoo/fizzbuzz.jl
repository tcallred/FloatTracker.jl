# Inspired by "Fizz Buzz in Tensorflow" blog by Joel Grus
# http://joelgrus.com/2016/05/23/fizz-buzz-in-tensorflow/
using Flux: Chain, Dense, params, logitcrossentropy, onehotbatch, ADAM, train!, softmax
using Test
import FloatTracker
FloatTracker.set_logger("fizzbuzz", 5)
FloatTracker.set_exclude_stacktrace([:prop])

function TF(arr)
  return map(x -> FloatTracker.TrackedFloat64(x), arr)
end

# Data preparation
function fizzbuzz(x::Int)
    is_divisible_by_three = x % 3 == 0
    is_divisible_by_five = x % 5 == 0

    if is_divisible_by_three & is_divisible_by_five
        return "fizzbuzz"
    elseif is_divisible_by_three
        return "fizz"
    elseif is_divisible_by_five
        return "buzz"
    else
        return "else"
    end
end

const LABELS = ["fizz", "buzz", "fizzbuzz", "else"];

# Feature engineering
features(x) = TF(float.([x % 3, x % 5, x % 15]))
features(x::AbstractArray) = TF(hcat(features.(x)...))

function getdata()
    
    @test fizzbuzz.([3, 5, 15, 98]) == LABELS
    
    raw_x = 1:100;
    raw_y = fizzbuzz.(raw_x);
    
    X = TF(features(raw_x));
    y = TF(onehotbatch(raw_y, LABELS));
    return X, y
end

function train()

    # Get Data
    X, y = getdata()

    # Model	
    m = Chain(Dense(3, 10), Dense(10, 4))
    loss(x, y) = logitcrossentropy(m(x), y)

    # Helpers
    deepbuzz(x) = (a = argmax(m(features(x))); a == 4 ? x : LABELS[a])	
	
    function monitor(e)
    	print("epoch $(lpad(e, 4)): loss = $(round(loss(X,y))) | ")
        @show deepbuzz.(TF([3, 5, 15, 98]))
    end

    opt = ADAM()
    # Training
    for e in 0:150 #500
        train!(loss, params(m), [(X, y)], opt)
        if e % 50 == 0
            monitor(e) 
        end
    end
end

train()

FloatTracker.write_log_to_file()

