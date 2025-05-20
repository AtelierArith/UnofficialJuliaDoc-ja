```
randexp([rng=default_rng()], [T=Float64], [dims...])
```

Generate a random number of type `T` according to the exponential distribution with scale 1. Optionally generate an array of such random numbers. The `Base` module currently provides an implementation for the types [`Float16`](@ref), [`Float32`](@ref), and [`Float64`](@ref) (the default).

# Examples

```jldoctest
julia> rng = Xoshiro(123);

julia> randexp(rng, Float32)
1.1757717f0

julia> randexp(rng, 3, 3)
3×3 Matrix{Float64}:
 1.37766  0.456653  0.236418
 3.40007  0.229917  0.0684921
 0.48096  0.577481  0.71835
```
