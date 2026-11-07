```julia
cis(x)
```

オイラーの公式を使うと、`exp(im*x)`をより効率的に求められます：``\cos(x) + i \sin(x) = \exp(i x)``。

こちらも参照してください：[`cispi`](@ref)、[`sincos`](@ref)、[`exp`](@ref)、[`angle`](@ref)。

# Examples

```jldoctest
julia> cis(π) ≈ -1
true
```
