struct Logger 
  events::Array{String}
end

const capacity = 50
logger = Logger([])

function log_event(evt::Event) 
  push!(logger.events, to_string(evt))
end

function print_log()
  for e in logger.events
    println(e)
  end
end
