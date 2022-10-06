using Dates 

struct Logger 
  events::Array{String}
end

logger = Logger([])

function log_event(evt::Event, should_print = false) 
  push!(logger.events, to_string(evt))
  if should_print 
    println(to_string(evt))
  end
end

function print_log()
  for e in logger.events
    println(e)
  end
end

function write_log_to_file(;file_name="filename") 
  time = now().instant.periods.value % 99999999
  if length(logger.events) > 0
    open("$(file_name)_error_log_$(time).txt", "w") do file
      for e in logger.events
        write(file, "$e\n\n")
      end
    end
  end
end
