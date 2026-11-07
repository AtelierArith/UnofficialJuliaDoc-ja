```julia
randn([rng=default_rng()], [T=Float64], [dims...])
```

Generate a normally-distributed random number of type `T` with mean 0 and standard deviation 1. Given the optional `dims` argument(s), generate an array of size `dims` of such numbers. Julia's standard library supports `randn` for any floating-point type that implements [`rand`](@ref), e.g. the `Base` types [`Float16`](@ref), [`Float32`](@ref), [`Float64`](@ref) (the default), and [`BigFloat`](@ref), along with their [`Complex`](@ref) counterparts.

(When `T` is complex, the values are drawn from the circularly symmetric complex normal distribution of variance 1, corresponding to real and imaginary parts having independent normal distribution with mean zero and variance `1/2`).

See also [`randn!`](@ref) to act in-place.

# Examples

Generating a single random number (with the default `Float64` type):

```julia-repl
julia> randn()
-0.942481877315864
```

Generating a matrix of normal random numbers (with the default `Float64` type):

```julia-repl
julia> randn(2,3)
2×3 Matrix{Float64}:
  1.18786   -0.678616   1.49463
 -0.342792  -0.134299  -1.45005
```

Setting up of the random number generator `rng` with a user-defined seed (for reproducible numbers) and using it to generate a random `Float32` number or a matrix of `ComplexF32` random numbers:

```jldoctest
julia> using Random

julia> rng = Xoshiro(123);

julia> randn(rng, Float32)
-0.6457307f0

julia> randn(rng, ComplexF32, (2, 3))
2×3 Matrix{ComplexF32}:
  -1.03467-1.14806im  0.693657+0.056538im   0.291442+0.419454im
 -0.153912+0.34807im    1.0954-0.948661im  -0.543347-0.0538589im
```
