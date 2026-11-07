```julia
set_peek_duration(t::Float64)
```

Set the duration in seconds of the profile "peek" that is triggered via `SIGINFO` or `SIGUSR1`, depending on platform.
