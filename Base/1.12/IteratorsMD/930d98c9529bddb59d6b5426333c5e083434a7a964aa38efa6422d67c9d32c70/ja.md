```julia
CartesianIndex(i, j, k...)   -> I
CartesianIndex((i, j, k...)) -> I
```

多次元インデックス `I` を作成します。これは多次元配列 `A` のインデックス付けに使用できます。特に、`A[I]` は `A[i,j,k...]` と同等です。整数と `CartesianIndex` インデックスを自由に混ぜることができます。例えば、`A[Ipre, i, Ipost]`（ここで `Ipre` と `Ipost` は `CartesianIndex` インデックスで、`i` は `Int`）は、任意の次元の配列の単一の次元に沿って動作するアルゴリズムを書く際に便利な表現です。

`CartesianIndex` は、[`eachindex`](@ref) によって生成されることがあり、明示的に [`CartesianIndices`](@ref) を使用して反復する際には常に生成されます。

`I::CartesianIndex` は `broadcast` のための「スカラー」（コンテナではない）として扱われます。`CartesianIndex` のコンポーネントを反復するには、`Tuple(I)` を使用してタプルに変換します。

# 例

```jldoctest
julia> A = reshape(Vector(1:16), (2, 2, 2, 2))
2×2×2×2 Array{Int64, 4}:
[:, :, 1, 1] =
 1  3
 2  4

[:, :, 2, 1] =
 5  7
 6  8

[:, :, 1, 2] =
  9  11
 10  12

[:, :, 2, 2] =
 13  15
 14  16

julia> A[CartesianIndex((1, 1, 1, 1))]
1

julia> A[CartesianIndex((1, 1, 1, 2))]
9

julia> A[CartesianIndex((1, 1, 2, 1))]
5
```

!!! compat "Julia 1.10"
    `broadcast` のための「スカラー」として `CartesianIndex` を使用するには Julia 1.10 が必要です。以前のリリースでは、`Ref(I)` を使用してください。

