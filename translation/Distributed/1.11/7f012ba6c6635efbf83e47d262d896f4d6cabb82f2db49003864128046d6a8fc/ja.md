```julia
remotecall_eval(m::Module, procs, expression)
```

`procs`で指定されたプロセス上で、モジュール`m`の式を実行します。いずれかのプロセスで発生したエラーは[`CompositeException`](@ref)にまとめられ、スローされます。

[`@everywhere`](@ref)も参照してください。
