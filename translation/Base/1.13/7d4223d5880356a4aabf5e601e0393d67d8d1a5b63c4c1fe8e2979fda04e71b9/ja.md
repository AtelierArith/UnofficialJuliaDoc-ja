```julia
floatmax(T = Float64)
```

浮動小数点型 `T` で表現可能な最大の有限数を返します。

関連項目: [`typemax`](@ref)、[`maxintfloat`](@ref)、[`floatmin`](@ref)、[`eps`](@ref)。

# Examples

```jldoctest
julia> floatmax(Float16)
Float16(6.55e4)

julia> floatmax(Float32)
3.4028235f38

julia> floatmax()
1.7976931348623157e308

julia> typemax(Float64)
Inf
```
