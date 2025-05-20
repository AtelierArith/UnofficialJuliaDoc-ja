```
InterruptException()
```

The process was stopped by a terminal interrupt (CTRL+C).

Note that, in Julia script started without `-i` (interactive) option, `InterruptException` is not thrown by default.  Calling [`Base.exit_on_sigint(false)`](@ref Base.exit_on_sigint) in the script can recover the behavior of the REPL.  Alternatively, a Julia script can be started with

```sh
julia -e "include(popfirst!(ARGS))" script.jl
```

to let `InterruptException` be thrown by CTRL+C during the execution.
