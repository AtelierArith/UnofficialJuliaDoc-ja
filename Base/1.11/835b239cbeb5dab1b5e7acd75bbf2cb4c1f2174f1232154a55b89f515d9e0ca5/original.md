```
exit_on_sigint(on::Bool)
```

Set `exit_on_sigint` flag of the julia runtime.  If `false`, Ctrl-C (SIGINT) is capturable as [`InterruptException`](@ref) in `try` block. This is the default behavior in REPL, any code run via `-e` and `-E` and in Julia script run with `-i` option.

If `true`, `InterruptException` is not thrown by Ctrl-C.  Running code upon such event requires [`atexit`](@ref).  This is the default behavior in Julia script run without `-i` option.

!!! compat "Julia 1.5"
    Function `exit_on_sigint` requires at least Julia 1.5.

