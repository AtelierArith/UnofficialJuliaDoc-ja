```julia
remotecall_eval(m::Module, procs, expression)
```

`m` モジュールの式を、`procs` で指定されたプロセス上で実行します。いずれかのプロセスで発生したエラーは [`CompositeException`](@ref) にまとめられ、スローされます。

[`@everywhere`](@ref) も参照してください。
