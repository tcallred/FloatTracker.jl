abstract type AbstractTrackedFloat <: AbstractFloat end

struct Event
  evt_type::Symbol
  op::String
  args::Array{Any}
  result::AbstractFloat
end

function event(op, args, result) :: Event
  evt_type = 
    if all(arg -> !isnan(arg), args) && isnan(result)
      :gen
    elseif any(arg -> isnan(arg), args) && isnan(result)
      :prop
    elseif any(arg -> isnan(arg), args) && !isnan(result)
      :kill
    end

  Event(evt_type, op, args, result)
end

# Base.show(io::IO, e::Event) = print(io,"$e.evt_type: $e.args -> $e.op -> $e.result")

for TrackedFloatN in (:TrackedFloat16, :TrackedFloat32, :TrackedFloat64)

# FloatN is the base float type derived from TrackedFloatN 
@eval FloatN = $(Symbol("Float", string(TrackedFloatN)[end-1:end]))

@eval begin 
  struct $TrackedFloatN <: AbstractTrackedFloat
    val::$FloatN
    journey::Array{Event}
  end

  Base.Float64(x::$TrackedFloatN) = Float64(x.val)
  Base.Float32(x::$TrackedFloatN) = Float32(x.val)
  Base.Float16(x::$TrackedFloatN) = Float16(x.val)
  Base.Int64(x::$TrackedFloatN) = Int64(x.val)
  Base.Int32(x::$TrackedFloatN) = Int32(x.val)
  Base.Int16(x::$TrackedFloatN) = Int16(x.val)

  Base.bitstring(x::$TrackedFloatN) = bitstring(x.val)
  Base.show(io::IO,x::$TrackedFloatN) = print(io ,$TrackedFloatN,"(",string(x.val),")")

  $TrackedFloatN(x::AbstractFloat) = $TrackedFloatN(x, [])
  $TrackedFloatN(x::Integer) = $TrackedFloatN(x, [])
  $TrackedFloatN(x::Bool)= if x $TrackedFloatN(1, []) else $TrackedFloatN(0, []) end


  Base.promote_rule(::Type{<:Integer},::Type{$TrackedFloatN}) = $TrackedFloatN
  Base.promote_rule(::Type{Float64},::Type{$TrackedFloatN}) = $TrackedFloatN
  Base.promote_rule(::Type{Float32},::Type{$TrackedFloatN}) = $TrackedFloatN
  Base.promote_rule(::Type{Float16},::Type{$TrackedFloatN}) = $TrackedFloatN 
  Base.promote_rule(::Type{Bool},::Type{$TrackedFloatN}) = $TrackedFloatN 
end


for O in (:(+), :(-), :(*), :(/), :(^))
    @eval function Base.$O(x::$TrackedFloatN,y::$TrackedFloatN)
        r = $O(x.val, y.val)
        if any(v -> isnan(v), [x.val, y.val, r]) 
          e = event(string($O), [x.val, y.val], r)
          j = [x.journey; y.journey; e] 
          return $TrackedFloatN(r, j)
        end
        $TrackedFloatN(r, [])
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
          e = event(string($O), [x.val], r)
          j = [x.journey; e] 
          return $TrackedFloatN(r, j)
        end
        $TrackedFloatN(r, [])
    end
end

@eval Base.eps(::Type{$TrackedFloatN}) = eps($FloatN)

for O in (:(<), :(<=))
    @eval function Base.$O(x::$TrackedFloatN, y::$TrackedFloatN)
      r = $O(x.val, y.val)
      if any(v -> isnan(v), [x.val, y.val]) 
          e = event(string($O), [x.val, y.val], r)
          j = [x.journey; y.journey; e] 
          for evt in j 
            println(evt)
          end
      end
      r
    end
end

end
