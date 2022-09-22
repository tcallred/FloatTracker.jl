using Dates 

struct Logger 
  events::Array{String}
end

logger = Logger([])

function log_event(evt::Event) 
  push!(logger.events, to_string(evt))
end

function print_log()
  for e in logger.events
    println(e)
  end
end

function write_log_to_file(;file_name="") 
  if length(logger.events) > 0
    open("$(file_name)_error_log_$(now()).txt", "w") do file
      for e in logger.events
        write(file, "$e\n\n")
      end
    end
  end
end
