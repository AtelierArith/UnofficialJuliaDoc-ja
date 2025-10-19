```julia
errormonitor(t::Task)
```

タスク `t` が失敗した場合、`stderr` にエラーログを出力します。

# 例

```julia-repl
julia> wait(errormonitor(Threads.@spawn error("task failed")); throw = false)
Unhandled Task ERROR: task failed
Stacktrace:
[...]
```
