```julia
ExponentialBackOff(; n=1, first_delay=0.05, max_delay=10.0, factor=5.0, jitter=0.1)
```

A [`Float64`](@ref) iterator of length `n` whose elements exponentially increase at a rate in the interval `factor` * (1 ± `jitter`).  The first element is `first_delay` and all elements are clamped to `max_delay`.
