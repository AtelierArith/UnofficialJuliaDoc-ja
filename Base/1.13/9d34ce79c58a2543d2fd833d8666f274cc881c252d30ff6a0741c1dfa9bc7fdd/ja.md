```julia
errormonitor(t::Task)
```

タスク `t` が失敗した場合は、`stderr` にエラーログを出力します。

# Examples

```julia-repl
julia> wait(errormonitor(Threads.@spawn error("task failed")); throw = false)
Unhandled Task ERROR: task failed
Stacktrace:
[...]
```
