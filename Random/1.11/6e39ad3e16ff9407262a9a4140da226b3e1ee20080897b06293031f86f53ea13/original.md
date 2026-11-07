```julia
randexp!([rng=default_rng()], A::AbstractArray) -> A
```

Fill the array `A` with random numbers following the exponential distribution (with scale 1).

# Examples

```jldoctest
julia> randexp!(Xoshiro(123), zeros(5))
5-element Vector{Float64}:
 1.1757716836348473
 1.758884569451514
 1.0083623637301151
 0.3510644315565272
 0.6348266443720407
```
