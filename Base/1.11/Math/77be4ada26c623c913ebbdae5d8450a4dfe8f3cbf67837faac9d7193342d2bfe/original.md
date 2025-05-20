```
exp(x)
```

Compute the natural base exponential of `x`, in other words $ℯ^x$.

See also [`exp2`](@ref), [`exp10`](@ref) and [`cis`](@ref).

# Examples

```jldoctest
julia> exp(1.0)
2.718281828459045

julia> exp(im * pi) ≈ cis(pi)
true
```
