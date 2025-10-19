```julia
remotecall_eval(m::Module, procs, expression)
```

モジュール `m` の下で、`procs` で指定されたプロセス上で式を実行します。いずれかのプロセスでのエラーは [`CompositeException`](@ref) に収集され、スローされます。

他にも [`@everywhere`](@ref) を参照してください。
