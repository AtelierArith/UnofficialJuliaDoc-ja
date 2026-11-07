```julia
fetch(t::Task)
```

[`Task`](@ref) の完了を待ってから、その結果の値を返します。タスクが例外で失敗した場合は、失敗したタスクをラップする [`TaskFailedException`](@ref) がスローされます。
