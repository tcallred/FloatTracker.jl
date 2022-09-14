
@inline function isfloaterror(x)
  x isa AbstractFloat && (isnan(x) || isinf(x) || issubnormal(x))
end

struct Event
  evt_type::Symbol
  op::String
  args::Array{Any}
  result::Any
  trace::StackTraces.StackTrace
end

function event(op, args, result) :: Event
  evt_type = 
    if all(arg -> !isfloaterror(arg), args) && isfloaterror(result)
      :gen
    elseif any(arg -> isfloaterror(arg), args) && isfloaterror(result)
      :prop
    elseif any(arg -> isfloaterror(arg), args) && !isfloaterror(result)
      :kill
    end

  Event(evt_type, op, args, result, stacktrace()[2:end])
end

function to_string(evt::Event) 
  sts = join(["\t$st" for st in evt.trace], "\n")
  return "$(uppercase(string(evt.evt_type))) $(join(evt.args, ",")) -> $(evt.op) -> $(evt.result)\n $sts"
end
