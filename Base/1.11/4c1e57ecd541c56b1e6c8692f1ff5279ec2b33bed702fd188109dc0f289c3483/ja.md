```
cumsum(A; dims::Integer)
```

次元 `dims` に沿った累積和。パフォーマンスのために事前に割り当てられた出力配列を使用するには、[`cumsum!`](@ref) も参照してください。また、出力の精度を制御するため（例えば、オーバーフローを避けるため）にも使用できます。

# 例

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
    戻り値の配列の `eltype` は、システムのワードサイズ未満の符号付き整数の場合は `Int`、システムのワードサイズ未満の符号なし整数の場合は `UInt` です。小さな符号付きまたは符号なし整数の配列の `eltype` を保持するには、`accumulate(+, A)` を使用する必要があります。

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

    前者の場合、整数はシステムのワードサイズに拡張され、そのため結果は `Int64[100, 128]` になります。後者の場合、そのような拡張は行われず、整数のオーバーフローが `Int8[100, -128]` になります。

