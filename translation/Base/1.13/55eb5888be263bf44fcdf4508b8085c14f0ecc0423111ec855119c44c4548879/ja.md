```julia
TaskFailedException
```

この例外は、タスク `t` が失敗したときに、[`wait(t)`](@ref) の呼び出しによってスローされます。`TaskFailedException` は、失敗したタスク `t` をラップします。
