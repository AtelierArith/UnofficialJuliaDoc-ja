```julia
Sys.detectwsl()
```

Runtime predicate for testing if Julia is running inside Windows Subsystem for Linux (WSL).

!!! note
    Unlike `Sys.iswindows`, `Sys.islinux` etc., this is a runtime test, and thus cannot meaningfully be used in `@static if` constructs.


!!! compat "Julia 1.12"
    This function requires at least Julia 1.12.

