```
errormonitor(t::Task)
```

タスク `t` が失敗した場合、`stderr` にエラーログを出力します。

# 例

```julia-repl
julia> Base._wait(errormonitor(Threads.@spawn error("task failed")))
Unhandled Task ERROR: task failed
Stacktrace:
[...]
```
