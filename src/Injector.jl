struct FunctionRef
  name::Symbol
  file::Symbol
end

mutable struct Injector
  active::Bool
  odds::Int
  ninject::Int
  functions::Array{FunctionRef}
end

function should_inject(i::Injector)
  if i.active && i.ninject > 0
    roll = rand(1:i.odds)
    if roll != 1 
      return false
    end
    in_right_fn = if isempty(i.functions)
      true
    else
      in_functions = function (st)
        file = Symbol(split(String(st.file), ['/', '\\'])[end])
        fr = FunctionRef(st.func, file) 
        fr in i.functions
      end
      any(in_functions, stacktrace())
    end
    return roll == 1 && in_right_fn
  end
  return false
end

function decrment_injections(i::Injector)
  i.ninject = i.ninject - 1
end
