```julia
LogRecord
```

Stores the results of a single log event. Fields:

  * `level`: the [`LogLevel`](@ref) of the log message
  * `message`: the textual content of the log message
  * `_module`: the module of the log event
  * `group`: the logging group (by default, the name of the file containing the log event)
  * `id`: the ID of the log event
  * `file`: the file containing the log event
  * `line`: the line within the file of the log event
  * `kwargs`: any keyword arguments passed to the log event
