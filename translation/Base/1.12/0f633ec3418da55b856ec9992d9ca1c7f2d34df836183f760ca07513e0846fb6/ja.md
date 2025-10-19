```julia
fetch(t::Task)
```

[`Task`](@ref) が終了するのを待ってから、その結果の値を返します。タスクが例外で失敗した場合、失敗したタスクをラップした [`TaskFailedException`](@ref) がスローされます。
