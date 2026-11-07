```julia
div(x, y)
÷(x, y)
```

ユークリッド除法（整数除法）による商。一般に、分数部分を除いた数学的な演算 x/y に相当します。

関連項目: [`cld`](@ref)、[`fld`](@ref)、[`rem`](@ref)、[`divrem`](@ref)。

# Examples

```jldoctest
julia> 9 ÷ 4
2

julia> -5 ÷ 3
-1

julia> 5.0 ÷ 2
2.0

julia> div.(-5:5, 3)'
1×11 adjoint(::Vector{Int64}) with eltype Int64:
 -1  -1  -1  0  0  0  0  0  1  1  1
```
