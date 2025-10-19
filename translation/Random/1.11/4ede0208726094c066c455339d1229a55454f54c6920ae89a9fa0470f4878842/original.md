```julia
seed!([rng=default_rng()], seed) -> rng
seed!([rng=default_rng()]) -> rng
```

Reseed the random number generator: `rng` will give a reproducible sequence of numbers if and only if a `seed` is provided. Some RNGs don't accept a seed, like `RandomDevice`. After the call to `seed!`, `rng` is equivalent to a newly created object initialized with the same seed. The types of accepted seeds depend on the type of `rng`, but in general, integer seeds should work.

If `rng` is not specified, it defaults to seeding the state of the shared task-local generator.

# Examples

```julia-repl
julia> Random.seed!(1234);

julia> x1 = rand(2)
2-element Vector{Float64}:
 0.32597672886359486
 0.5490511363155669

julia> Random.seed!(1234);

julia> x2 = rand(2)
2-element Vector{Float64}:
 0.32597672886359486
 0.5490511363155669

julia> x1 == x2
true

julia> rng = Xoshiro(1234); rand(rng, 2) == x1
true

julia> Xoshiro(1) == Random.seed!(rng, 1)
true

julia> rand(Random.seed!(rng), Bool) # not reproducible
true

julia> rand(Random.seed!(rng), Bool) # not reproducible either
false

julia> rand(Xoshiro(), Bool) # not reproducible either
true
```
