```
reduce(f, A::AbstractArray; dims=:, [init])
```

2引数関数 `f` を `A` の次元に沿って縮小します。`dims` は縮小する次元を指定するベクトルであり、キーワード引数 `init` は縮小に使用する初期値です。`+`、`*`、`max` および `min` の場合、`init` 引数はオプションです。

縮小の結合性は実装に依存します。特定の結合性、例えば左から右への結合性が必要な場合は、自分自身のループを書くか、[`foldl`](@ref) または [`foldr`](@ref) の使用を検討してください。[`reduce`](@ref) のドキュメントを参照してください。

# 例

```jldoctest
julia> a = reshape(Vector(1:16), (4,4))
4×4 Matrix{Int64}:
 1  5   9  13
 2  6  10  14
 3  7  11  15
 4  8  12  16

julia> reduce(max, a, dims=2)
4×1 Matrix{Int64}:
 13
 14
 15
 16

julia> reduce(max, a, dims=1)
1×4 Matrix{Int64}:
 4  8  12  16
```
