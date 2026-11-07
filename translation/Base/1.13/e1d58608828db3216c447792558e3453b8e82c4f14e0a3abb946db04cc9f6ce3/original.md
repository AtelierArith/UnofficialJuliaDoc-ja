```julia
promote_rule(type1, type2)
```

Specifies what type should be used by [`promote`](@ref) when given values of types `type1` and `type2`. This function should not be called directly, but should have definitions added to it for new types as appropriate.
