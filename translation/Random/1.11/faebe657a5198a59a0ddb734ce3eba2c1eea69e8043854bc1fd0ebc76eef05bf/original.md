```julia
shuffle!([rng=default_rng(),] v::AbstractArray)
```

In-place version of [`shuffle`](@ref): randomly permute `v` in-place, optionally supplying the random-number generator `rng`.

# Examples

```jldoctest
julia> shuffle!(Xoshiro(0), Vector(1:6))
6-element Vector{Int64}:
 5
 1
 2
 6
 3
 4
```
