# Script to find NaN kills
dangerous_numbs = [pi, 0, 1, NaN, Inf, 1/pi]

for x in dangerous_numbs

  # Skipped: rem2pi
  for mop in [(-), (+),
              sign,
              prevfloat, nextfloat,
              round, trunc, ceil, floor,
              inv, abs, sqrt, cbrt,
              exp, expm1, exp2, exp10,
              log, log1p, log2, log10,
              rad2deg, deg2rad, mod2pi, sin, cos, tan, csc, sec, cot,
              asin, acos, atan, acsc, asec, acot,
              sinh, cosh, tanh, csch, sech, coth,
              asinh, acosh, atanh, acsch, asech, acoth,
              sinc, sinpi, cospi,
              sind, cosd, tand, cscd, secd, cotd,
              asind, acosd, atand, acscd, asecd, acotd]
    try
      println("$mop $x → $(mop.(x))")
      if isnan(x) && ! isnan(mop.(x))
        println("KILL: $mop $x → $(mop.(x))")
      end
    catch e
      println("Failed: $mop $x: $e")
    end
  end

  for y in dangerous_numbs

    for bop in [(+), (-), (*), (/), (^), min, max, rem, <, >, ≤, ≥]
      try
        println("$x $(bop) $y → $(bop.(x, y))")
        if (isnan(x) || isnan(y)) && ! isnan(bop.(x, y))
          println("KILL: $x $bop $y → $(bop.(x, y))")
        end
      catch e
        println("Failed: $x $(bop) $y → $e")
      end
    end

    # Skipped: rem2pi
    for mop in [(-), (+),
                sign,
                prevfloat, nextfloat,
                round, trunc, ceil, floor,
                inv, abs, sqrt, cbrt,
                exp, expm1, exp2, exp10,
                log, log1p, log2, log10,
                rad2deg, deg2rad, mod2pi, sin, cos, tan, csc, sec, cot,
                asin, acos, atan, acsc, asec, acot,
                sinh, cosh, tanh, csch, sech, coth,
                asinh, acosh, atanh, acsch, asech, acoth,
                sinc, sinpi, cospi,
                sind, cosd, tand, cscd, secd, cotd,
                asind, acosd, atand, acscd, asecd, acotd]
      for bop in [(+), (-), (*), (/), (^), min, max, rem]
        try
          println("$mop ($x $bop $y) → $mop $(bop.(x, y)) → $(mop.(bop.(x, y)))")
          if isnan(bop.(x, y)) && ! isnan(mop.(bop.(x, y)))
            println("KILL: $mop ($x $bop $y) → $mop.(bop.(x, y))")
          end
        catch e
          println("Failed: $mop ($x $bop $y) → $e")
        end
      end
    end
  end
end
