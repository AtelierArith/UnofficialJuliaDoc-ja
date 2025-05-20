```
jump_128!(rng::Xoshiro, [n::Integer=1])
```

Jump forward, advancing the state equivalent to `2^128` calls which consume 8 bytes (i.e. a full `UInt64`) each.

If `n > 0` is provided, the state is advanced equivalent to `n * 2^128` calls; if `n = 0`, the state remains unchanged.

This can be used to generate `2^128` non-overlapping subsequences for parallel computations.

See also: [`jump_128`](@ref), [`jump_192!`](@ref)

# Examples

```julia-repl
julia> jump_128!(jump_128!(Xoshiro(1))) == jump_128!(Xoshiro(1), 2)
true
```
