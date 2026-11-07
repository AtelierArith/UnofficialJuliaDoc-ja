```julia
reverse(A; dims=:)
```

`A` を次元 `dims` に沿って反転します。次元には、整数（単一の次元）、整数のタプル（複数の次元）、または `:`（すべての次元に沿って反転、デフォルト）を指定できます。インプレースでの反転については、[`reverse!`](@ref) も参照してください。

# Examples

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
    Julia 1.6 より前の `reverse` では、`dims` として単一の整数のみがサポートされています。

