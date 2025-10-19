```julia
TaskFailedException
```

この例外は、タスク `t` が失敗したときに [`wait(t)`](@ref) 呼び出しによってスローされます。`TaskFailedException` は失敗したタスク `t` をラップします。
