```julia
withenv(f, kv::Pair...)
```

Execute `f` in an environment that is temporarily modified (not replaced as in `setenv`) by zero or more `"var"=>val` arguments `kv`. `withenv` is generally used via the `withenv(kv...) do ... end` syntax. A value of `nothing` can be used to temporarily unset an environment variable (if it is set). When `withenv` returns, the original environment has been restored.

!!! warning
    Changing the environment is not thread-safe. For running external commands with a different environment from the parent process, prefer using [`addenv`](@ref) over `withenv`.

