function log_message(op, args, result) :: String
  if all(arg -> !isnan(arg), args) && isnan(result)
    return "Gen: $args -> $op -> $result"
  elseif any(arg -> isnan(arg), args) && isnan(result)
    return "Prop: $args -> $op -> $result"
  elseif any(arg -> isnan(arg), args) && !isnan(result)
    return "Kill: $args -> $op -> $result"
  end
end

abstract type AbstractTrackedFloat <: AbstractFloat end

for TrackedFloatN in (:TrackedFloat16, :TrackedFloat32, :TrackedFloat64)

# FloatN is the base float type derived from TrackedFloatN 
@eval FloatN = $(Symbol("Float", string(TrackedFloatN)[end-1:end]))

@eval begin 
  struct $TrackedFloatN <: AbstractTrackedFloat
    val::$FloatN
  end

  Base.bitstring(x::$TrackedFloatN) = bitstring(x.val)
  Base.show(io::IO,x::$TrackedFloatN) = print(io ,$TrackedFloatN,"(",string(x.val),")")

end

for O in (:(+), :(-), :(*), :(/), :(^))
    @eval function Base.$O(x::$TrackedFloatN,y::$TrackedFloatN)
        r = $O(x.val, y.val)
        if any(v -> isnan(v), [x.val, y.val, r]) 
          println(log_message(string($O), [x.val, y.val], r))
        end
        $TrackedFloatN(r)
    end
end

for O in (:(-), :(+),
          :sign,
          :prevfloat, :nextfloat,
          :round, :trunc, :ceil, :floor,
          :inv, :abs, :sqrt, :cbrt,
          :exp, :expm1, :exp2, :exp10,
          :log, :log1p, :log2, :log10,
          :rad2deg, :deg2rad, :mod2pi, :rem2pi,
          :sin, :cos, :tan, :csc, :sec, :cot,
          :asin, :acos, :atan, :acsc, :asec, :acot,
          :sinh, :cosh, :tanh, :csch, :sech, :coth,
          :asinh, :acosh, :atanh, :acsch, :asech, :acoth,
          :sinc, :sinpi, :cospi,
          :sind, :cosd, :tand, :cscd, :secd, :cotd,
          :asind, :acosd, :atand, :acscd, :asecd, :acotd
         )
    @eval function Base.$O(x::$TrackedFloatN)
        r = $O(x.val)
        if any(v -> isnan(v), [x.val, r]) 
          println(log_message(string($O), [x.val], r))
        end
        $TrackedFloatN(r)
    end
end

for O in (:(<), :(<=))
    @eval function Base.$O(x::$TrackedFloatN, y::$TrackedFloatN)
      r = $O(x.val, y.val)
      if any(v -> isnan(v), [x.val, y.val]) 
        println(log_message(string($O), [x.val, y.val], r))
      end
      r
    end
end

end
