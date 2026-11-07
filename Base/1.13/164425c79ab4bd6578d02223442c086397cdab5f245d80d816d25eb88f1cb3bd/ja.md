```julia
zero(x)
zero(::Type)
```

`x`の加法単位元を取得します。加法単位元が型だけから推論できる場合は、`zero`の引数に型を指定できます。

たとえば、`zero(Int)`は、`Int`のすべてのインスタンスで加法単位元が同じなので動作します。一方、長さの異なるベクトルでは加法単位元も異なるため、`zero(Vector{Int})`は定義されていません。

関連項目: [`iszero`](@ref)、[`one`](@ref)、[`oneunit`](@ref)、[`oftype`](@ref)。

# Examples

```jldoctest
julia> zero(1)
0

julia> zero(big"2.0")
0.0

julia> zero(rand(2,2))
2×2 Matrix{Float64}:
 0.0  0.0
 0.0  0.0
```
