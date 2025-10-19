```julia
shuffle!([rng=default_rng(),] v::AbstractArray)
```

In-place version of [`shuffle`](@ref): randomly permute `v` in-place, optionally supplying the random-number generator `rng`.

# Examples

```jldoctest
julia> shuffle!(Xoshiro(123), Vector(1:10))
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
