```julia
uuid1([rng::AbstractRNG]) -> UUID
```

Generates a version 1 (time-based) universally unique identifier (UUID), as specified by [RFC 4122](https://tools.ietf.org/html/rfc4122). Note that the Node ID is randomly generated (does not identify the host) according to section 4.5 of the RFC.

The default rng used by `uuid1` is not `Random.default_rng()` and every invocation of `uuid1()` without an argument should be expected to return a unique identifier. Importantly, the outputs of `uuid1` do not repeat even when `Random.seed!(seed)` is called. Currently (as of Julia 1.6), `uuid1` uses `Random.RandomDevice` as the default rng. However, this is an implementation detail that may change in the future.

!!! compat "Julia 1.6"
    The output of `uuid1` does not depend on `Random.default_rng()` as of Julia 1.6.


# Examples

```jldoctest; filter = r"[a-z0-9]{8}-([a-z0-9]{4}-){3}[a-z0-9]{12}"
julia> using Random

julia> rng = MersenneTwister(1234);

julia> uuid1(rng)
UUID("cfc395e8-590f-11e8-1f13-43a2532b2fa8")
```
