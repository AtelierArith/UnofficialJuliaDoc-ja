```
Sys.isnetbsd([os])
```

Predicate for testing if the OS is a derivative of NetBSD. See documentation in [Handling Operating System Variation](@ref).

!!! note
    Not to be confused with `Sys.isbsd()`, which is `true` on NetBSD but also on other BSD-based systems. `Sys.isnetbsd()` refers only to NetBSD.


!!! compat "Julia 1.1"
    This function requires at least Julia 1.1.

