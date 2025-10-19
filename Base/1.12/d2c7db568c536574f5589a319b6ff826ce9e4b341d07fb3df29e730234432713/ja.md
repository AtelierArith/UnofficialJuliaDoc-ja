```julia
div(x, y)
÷(x, y)
```

ユークリッド（整数）除算からの商。一般的には、分数部分のない数学的操作 x/y に相当します。

参照: [`cld`](@ref), [`fld`](@ref), [`rem`](@ref), [`divrem`](@ref).

# 例

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
