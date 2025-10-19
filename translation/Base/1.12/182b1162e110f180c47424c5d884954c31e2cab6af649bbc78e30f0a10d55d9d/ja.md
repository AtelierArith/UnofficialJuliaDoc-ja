```julia
zero(x)
zero(::Type)
```

`x`の加法単位元を取得します。加法単位元が型からのみ推測できる場合、型を引数として`zero`に渡すことができます。

例えば、`zero(Int)`は動作します。なぜなら、加法単位元はすべての`Int`のインスタンスで同じだからですが、`zero(Vector{Int})`は異なる長さのベクトルが異なる加法単位元を持つため、定義されていません。

他にも[`iszero`](@ref)、[`one`](@ref)、[`oneunit`](@ref)、[`oftype`](@ref)を参照してください。

# 例

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
