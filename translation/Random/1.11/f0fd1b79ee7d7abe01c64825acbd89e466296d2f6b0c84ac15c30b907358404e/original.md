```julia
MersenneTwister(seed)
MersenneTwister()
```

Create a `MersenneTwister` RNG object. Different RNG objects can have their own seeds, which may be useful for generating different streams of random numbers. The `seed` may be an integer, a string, or a vector of `UInt32` integers. If no seed is provided, a randomly generated one is created (using entropy from the system). See the [`seed!`](@ref) function for reseeding an already existing `MersenneTwister` object.

!!! compat "Julia 1.11"
    Passing a negative integer seed requires at least Julia 1.11.


# Examples

```jldoctest
julia> rng = MersenneTwister(123);

julia> x1 = rand(rng, 2)
2-element Vector{Float64}:
 0.37453777969575874
 0.8735343642013971

julia> x2 = rand(MersenneTwister(123), 2)
2-element Vector{Float64}:
 0.37453777969575874
 0.8735343642013971

julia> x1 == x2
true
```
