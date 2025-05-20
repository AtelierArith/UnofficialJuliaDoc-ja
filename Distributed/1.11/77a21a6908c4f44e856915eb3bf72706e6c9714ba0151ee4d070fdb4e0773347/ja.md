```
remotecall_eval(m::Module, procs, expression)
```

モジュール `m` の下で、指定されたプロセス `procs` で式を実行します。プロセスのいずれかで発生したエラーは [`CompositeException`](@ref) に収集され、スローされます。

また、[`@everywhere`](@ref) も参照してください。
