```julia
uuid7([rng::AbstractRNG]) -> UUID
```

Generates a version 7 (random or pseudo-random) universally unique identifier (UUID), as specified by [RFC 9562](https://tools.ietf.org/html/rfc9562).

The default rng used by `uuid7` is not `Random.default_rng()` and every invocation of `uuid7()` without an argument should be expected to return a unique identifier. Importantly, the outputs of `uuid7` do not repeat even when `Random.seed!(seed)` is called. Currently (as of Julia 1.12), `uuid7` uses `Random.RandomDevice` as the default rng. However, this is an implementation detail that may change in the future.

!!! compat "Julia 1.12"
    `uuid7()` is available as of Julia 1.12.


# Examples

```jldoctest; filter = r"[a-z0-9]{8}-([a-z0-9]{4}-){3}[a-z0-9]{12}"
julia> using Random

julia> rng = Xoshiro(123);

julia> uuid7(rng)
UUID("019026ca-e086-772a-9638-f7b8557cd282")
```
