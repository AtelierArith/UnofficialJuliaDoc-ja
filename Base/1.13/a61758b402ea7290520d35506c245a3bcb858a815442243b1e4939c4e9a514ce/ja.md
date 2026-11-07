```julia
float(x)
```

数値または配列を浮動小数点型に変換します。

関連項目: [`complex`](@ref)、[`oftype`](@ref)、[`convert`](@ref)。

# Examples

```jldoctest
julia> float(typemax(Int32))
2.147483647e9
```
