```julia
errormonitor(t::Task)
```

Print an error log to `stderr` if task `t` fails.

# Examples

```julia-repl
julia> wait(errormonitor(Threads.@spawn error("task failed")); throw = false)
Unhandled Task ERROR: task failed
Stacktrace:
[...]
```
