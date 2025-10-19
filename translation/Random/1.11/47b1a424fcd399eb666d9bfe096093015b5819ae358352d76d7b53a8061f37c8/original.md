```julia
bitrand([rng=default_rng()], [dims...])
```

Generate a `BitArray` of random boolean values.

# Examples

```jldoctest
julia> bitrand(Xoshiro(123), 10)
10-element BitVector:
 0
 1
 0
 1
 0
 1
 0
 0
 1
 1
```
