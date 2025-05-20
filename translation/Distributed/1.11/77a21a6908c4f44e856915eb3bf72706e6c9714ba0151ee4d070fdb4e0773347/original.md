```
remotecall_eval(m::Module, procs, expression)
```

Execute an expression under module `m` on the processes specified in `procs`. Errors on any of the processes are collected into a [`CompositeException`](@ref) and thrown.

See also [`@everywhere`](@ref).
