```julia
rem(x, y)
%(x, y)
```

ユークリッド除算からの余りで、`x` と同じ符号を持ち、`y` よりも小さい絶対値の値を返します。この値は常に正確です。

参照: [`div`](@ref), [`mod`](@ref), [`mod1`](@ref), [`divrem`](@ref).

# 例

```jldoctest
julia> x = 15; y = 4;

julia> x % y
3

julia> x == div(x, y) * y + rem(x, y)
true

julia> rem.(-5:5, 3)'
1×11 adjoint(::Vector{Int64}) with eltype Int64:
 -2  -1  0  -2  -1  0  1  2  0  1  2
```
