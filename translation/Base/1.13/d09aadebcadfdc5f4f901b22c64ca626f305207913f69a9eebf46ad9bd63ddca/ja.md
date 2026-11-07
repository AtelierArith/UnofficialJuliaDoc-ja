```julia
cumsum(A; dims::Integer)
```

次元 `dims` に沿った累積和です。パフォーマンスの向上や、出力の精度を制御する（たとえばオーバーフローを避ける）ために、事前に確保した出力配列を使う場合は [`cumsum!`](@ref) も参照してください。

# Examples

```jldoctest
julia> a = [1 2 3; 4 5 6]
2×3 Matrix{Int64}:
 1  2  3
 4  5  6

julia> cumsum(a, dims=1)
2×3 Matrix{Int64}:
 1  2  3
 5  7  9

julia> cumsum(a, dims=2)
2×3 Matrix{Int64}:
 1  3   6
 4  9  15
```

!!! note
    戻り値の配列の `eltype` は、システムのワードサイズ未満の符号付き整数では `Int`、符号なし整数では `UInt` です。小さい符号付き整数または符号なし整数の配列の `eltype` を保持するには、`accumulate(+, A)` を使用してください。

    ```jldoctest
    julia> cumsum(Int8[100, 28])
    2-element Vector{Int64}:
     100
     128

    julia> accumulate(+,Int8[100, 28])
    2-element Vector{Int8}:
      100
     -128
    ```

    前者の場合、整数はシステムのワードサイズに拡張されるため、結果は `Int64[100, 128]` になります。後者の場合は拡張されず、整数オーバーフローが発生すると `Int8[100, -128]` になります。

