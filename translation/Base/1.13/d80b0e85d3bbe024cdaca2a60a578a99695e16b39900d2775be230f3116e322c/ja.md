```julia
floatmin(T = Float64)
```

浮動小数点型 `T` で表現可能な、最小の正規化数を返します。

関連項目: [`typemin`](@ref)、[`maxintfloat`](@ref)、[`floatmax`](@ref)、[`eps`](@ref)。

# Examples

```jldoctest
julia> floatmin(Float16)
Float16(6.104e-5)

julia> floatmin(Float32)
1.1754944f-38

julia> floatmin()
2.2250738585072014e-308
```
