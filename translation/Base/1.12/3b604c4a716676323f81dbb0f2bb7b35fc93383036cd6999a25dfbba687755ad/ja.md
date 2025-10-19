```julia
reverse(A; dims=:)
```

次元 `dims` に沿って `A` を反転します。`dims` は整数（単一の次元）、整数のタプル（次元のタプル）、または `:`（すべての次元に沿って反転、デフォルト）です。インプレース反転については、[`reverse!`](@ref)も参照してください。

# 例

```jldoctest
julia> b = Int64[1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> reverse(b, dims=2)
2×2 Matrix{Int64}:
 2  1
 4  3

julia> reverse(b)
2×2 Matrix{Int64}:
 4  3
 2  1
```

!!! compat "Julia 1.6"
    Julia 1.6以前は、`reverse` では単一の整数 `dims` のみがサポートされていました。

