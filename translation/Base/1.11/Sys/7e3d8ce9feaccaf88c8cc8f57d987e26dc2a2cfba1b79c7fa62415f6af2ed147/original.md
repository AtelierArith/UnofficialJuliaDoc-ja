```
Sys.isbsd([os])
```

Predicate for testing if the OS is a derivative of BSD. See documentation in [Handling Operating System Variation](@ref).

!!! note
    The Darwin kernel descends from BSD, which means that `Sys.isbsd()` is `true` on macOS systems. To exclude macOS from a predicate, use `Sys.isbsd() && !Sys.isapple()`.

