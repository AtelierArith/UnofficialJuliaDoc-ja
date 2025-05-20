```
Sys.isfreebsd([os])
```

Predicate for testing if the OS is a derivative of FreeBSD. See documentation in [Handling Operating System Variation](@ref).

!!! note
    Not to be confused with `Sys.isbsd()`, which is `true` on FreeBSD but also on other BSD-based systems. `Sys.isfreebsd()` refers only to FreeBSD.


!!! compat "Julia 1.1"
    This function requires at least Julia 1.1.

