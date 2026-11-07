```julia
TaskFailedException
```

タスク `t` が失敗すると、[`wait(t)`](@ref) の呼び出しによってこの例外がスローされます。`TaskFailedException` は、失敗したタスク `t` をラップします。
