```
systemsleep(s::Real)
```

Suspends execution for `s` seconds. This function does not yield to Julia's scheduler and therefore blocks the Julia thread that it is running on for the duration of the sleep time.

See also [`sleep`](@ref).
