```julia
@horner(x, p...)
```

Evaluate `p[1] + x * (p[2] + x * (....))`, i.e. a polynomial via Horner's rule.

See also [`@evalpoly`](@ref), [`evalpoly`](@ref).
