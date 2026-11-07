```julia
builtin_effects(𝕃::AbstractLattice, f::Builtin, argtypes::Vector{Any}, rt)::Effects
```

Compute the effects of a builtin function call. `argtypes` should not include `f` itself.
