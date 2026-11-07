```julia
Random.default_rng() -> rng
```

Return the default global random number generator (RNG), which is used by `rand`-related functions when no explicit RNG is provided.

When the `Random` module is loaded, the default RNG is *randomly* seeded, via [`Random.seed!()`](@ref): this means that each time a new julia session is started, the first call to `rand()` produces a different result, unless `seed!(seed)` is called first.

It is thread-safe: distinct threads can safely call `rand`-related functions on `default_rng()` concurrently, e.g. `rand(default_rng())`.

!!! note
    The type of the default RNG is an implementation detail. Across different versions of Julia, you should not expect the default RNG to always have the same type, nor that it will produce the same stream of random numbers for a given seed.


!!! compat "Julia 1.3"
    This function was introduced in Julia 1.3.

