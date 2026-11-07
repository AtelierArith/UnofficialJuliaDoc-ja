```julia
reduce(f, A::AbstractArray; dims=:, [init])
```

2引数関数 `f` を、`A` の次元に沿って縮約します。`dims` は縮約する次元を指定するベクトルで、キーワード引数 `init` は縮約の初期値です。`+`、`*`、`max`、`min` では、引数 `init` は省略できます。

縮約の結合順序は実装に依存します。左から右など、特定の結合順序が必要な場合は、独自のループを記述するか、[`foldl`](@ref) または [`foldr`](@ref) の使用を検討してください。[`reduce`](@ref) のドキュメントを参照してください。

# Examples

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
