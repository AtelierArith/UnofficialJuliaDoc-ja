```
LogLevel(level)
```

Severity/verbosity of a log record.

The log level provides a key against which potential log records may be filtered, before any other work is done to construct the log record data structure itself.

# Examples

```julia-repl
julia> Logging.LogLevel(0) == Logging.Info
true
```
