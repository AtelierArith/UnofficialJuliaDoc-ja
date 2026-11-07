```julia
catch_exceptions(logger)
```

Return `true` if the logger should catch exceptions which happen during log record construction.  By default, messages are caught.

By default all exceptions are caught to prevent log message generation from crashing the program.  This lets users confidently toggle little-used functionality - such as debug logging - in a production system.

If you want to use logging as an audit trail you should disable this for your logger type.
