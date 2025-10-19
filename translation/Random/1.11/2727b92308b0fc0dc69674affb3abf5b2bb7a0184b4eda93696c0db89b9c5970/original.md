```julia
shuffle([rng=default_rng(),] v::AbstractArray)
```

Return a randomly permuted copy of `v`. The optional `rng` argument specifies a random number generator (see [Random Numbers](@ref)). To permute `v` in-place, see [`shuffle!`](@ref). To obtain randomly permuted indices, see [`randperm`](@ref).

# Examples

```jldoctest
julia> shuffle(Xoshiro(123), Vector(1:10))
10-element Vector{Int64}:
  5
  4
  2
  3
  6
 10
  8
  1
  9
  7
```
