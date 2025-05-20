```
jump_192(rng::Xoshiro, [n::Integer=1])
```

Return a copy of `rng` with the state advanced equivalent to `n * 2^192` calls which consume 8 bytes (i.e. a full `UInt64`) each; if `n = 0`, the state of the returned copy will be identical to `rng`.

This can be used to generate `2^64` non-overlapping subsequences for parallel computations.

See also: [`jump_192!`](@ref), [`jump_128`](@ref)

# Examples

```julia-repl
julia> x = Xoshiro(1);

julia> jump_192(jump_192(x)) == jump_192(x, 2)
true

julia> jump_192(x, 0) == x
true

julia> jump_192(x, 0) === x
false
```
