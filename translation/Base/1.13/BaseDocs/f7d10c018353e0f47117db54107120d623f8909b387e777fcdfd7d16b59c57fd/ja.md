```julia
Bool <: Integer
```

値 `true` と `false` を持つブール型。

`Bool` は数値型の一種です。`false` は数値的に `0` と等しく、`true` は数値的に `1` と等しくなります。さらに、`false` は [`NaN`](@ref) および [`Inf`](@ref) に対して、乗法における「強いゼロ」として働きます。

```jldoctest
julia> [true, false] == [1, 0]
true

julia> 42.0 + true
43.0

julia> 0 .* (NaN, Inf, -Inf)
(NaN, NaN, NaN)

julia> false .* (NaN, Inf, -Inf)
(0.0, 0.0, -0.0)
```

[`if`](@ref) などの条件分岐が受け付けるのは、`Bool` のみです。Julia に「truthy」な値はありません。

比較演算は通常 `Bool` を返しますが、ブロードキャストされた比較では `Array{Bool}` の代わりに [`BitArray`](@ref) が返されることがあります。

```jldoctest
julia> [1 2 3 4 5] .< pi
1×5 BitMatrix:
 1  1  1  0  0

julia> map(>(pi), [1 2 3 4 5])
1×5 Matrix{Bool}:
 0  0  0  1  1
```

関連項目: [`trues`](@ref)、[`falses`](@ref)、[`ifelse`](@ref)。
