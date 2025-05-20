```
Sampler(rng, x, repetition = Val(Inf))
```

Return a sampler object that can be used to generate random values from `rng` for `x`.

When `sp = Sampler(rng, x, repetition)`, `rand(rng, sp)` will be used to draw random values, and should be defined accordingly.

`repetition` can be `Val(1)` or `Val(Inf)`, and should be used as a suggestion for deciding the amount of precomputation, if applicable.

[`Random.SamplerType`](@ref) and [`Random.SamplerTrivial`](@ref) are default fallbacks for *types* and *values*, respectively. [`Random.SamplerSimple`](@ref) can be used to store pre-computed values without defining extra types for only this purpose.
