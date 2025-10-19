```julia
TaskFailedException
```

This exception is thrown by a [`wait(t)`](@ref) call when task `t` fails. `TaskFailedException` wraps the failed task `t`.
