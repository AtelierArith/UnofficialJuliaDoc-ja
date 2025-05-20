```
errormonitor(t::Task)
```

Print an error log to `stderr` if task `t` fails.

# Examples

```julia-repl
julia> Base._wait(errormonitor(Threads.@spawn error("task failed")))
Unhandled Task ERROR: task failed
Stacktrace:
[...]
```
