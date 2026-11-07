```julia
CartesianIndex(i, j, k...)   -> I
CartesianIndex((i, j, k...)) -> I
```

多次元配列 `A` のインデックスとして使用できる、多次元インデックス `I` を作成します。特に、`A[I]` は `A[i,j,k...]` と同等です。整数インデックスと `CartesianIndex` インデックスは自由に組み合わせられます。たとえば、`A[Ipre, i, Ipost]`（`Ipre` と `Ipost` は `CartesianIndex` インデックス、`i` は `Int`）は、任意の次元数の配列について、単一の次元に沿って処理するアルゴリズムを書く際に便利な式です。

`CartesianIndex` は [`eachindex`](@ref) によって生成されることがあり、明示的な [`CartesianIndices`](@ref) を使って反復処理する場合には必ず生成されます。

`I::CartesianIndex` は、`broadcast` において「スカラー」（コンテナーではないもの）として扱われます。`CartesianIndex` の各要素を反復処理するには、`Tuple(I)` を使ってタプルに変換してください。

# Examples

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
    `CartesianIndex` を `broadcast` の「スカラー」として扱うには Julia 1.10 が必要です。それ以前のバージョンでは、`Ref(I)` を使用してください。

