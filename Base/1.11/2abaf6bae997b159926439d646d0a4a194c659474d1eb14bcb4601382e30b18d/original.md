```
cis(x)
```

More efficient method for `exp(im*x)` by using Euler's formula: $\cos(x) + i \sin(x) = \exp(i x)$.

See also [`cispi`](@ref), [`sincos`](@ref), [`exp`](@ref), [`angle`](@ref).

# Examples

```jldoctest
julia> cis(π) ≈ -1
true
```
