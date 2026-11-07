```julia
Inf, Inf64
```

型が [`Float64`](@ref) の正の無限大。

関連項目: [`isfinite`](@ref)、[`typemax`](@ref)、[`NaN`](@ref)、[`Inf32`](@ref)。

# Examples

```jldoctest
julia> π/0
Inf

julia> +1.0 / -0.0
-Inf

julia> ℯ^-Inf
0.0
```
