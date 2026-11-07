```julia
rem(x, y)
%(x, y)
```

ユークリッド除法の余りを返します。戻り値は`x`と同じ符号を持ち、絶対値は`y`より小さくなります。この値は常に正確です。

関連項目: [`div`](@ref)、[`mod`](@ref)、[`mod1`](@ref)、[`divrem`](@ref)。

# Examples

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
