using Dates 

mutable struct Logger 
  filename::String
  events::Array{String}
  buffersize::Int
end

logger = Logger("default", [], 5)

function set_logger(filename, buffersize=5)
  time = now().instant.periods.value % 99999999
  logger.filename = "$(filename)_$(time)"
  logger.buffersize = buffersize
end

function log_event(evt::Event, should_print = false) 
  push!(logger.events, to_string(evt))
  if should_print 
    println(to_string(evt))
  end
  if length(logger.events) >= logger.buffersize 
    write_log_to_file()
    logger.events = []
  end
end

function print_log()
  for e in logger.events
    println(e)
  end
end

function write_log_to_file() 
  if length(logger.events) > 0
    open("$(logger.filename)_error_log.txt", "a") do file
      for e in logger.events
        write(file, "$e\n\n")
      end
    end
  end
end
