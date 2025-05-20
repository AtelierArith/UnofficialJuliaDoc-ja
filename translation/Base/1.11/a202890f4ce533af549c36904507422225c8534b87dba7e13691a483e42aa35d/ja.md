```
accumulate!(op, B, A; [dims], [init])
```

累積演算 `op` を `A` に対して次元 `dims` に沿って行い、結果を `B` に格納します。ベクトルの場合、`dims` を指定することはオプションです。キーワード引数 `init` が指定されている場合、その値が累積の初期化に使用されます。

!!! warning
    変更された引数が他の引数とメモリを共有している場合、動作が予期しないものになることがあります。


関連項目として [`accumulate`](@ref)、[`cumsum!`](@ref)、[`cumprod!`](@ref) を参照してください。

# 例

```jldoctest
julia> x = [1, 0, 2, 0, 3];

julia> y = rand(5);

julia> accumulate!(+, y, x);

julia> y
5-element Vector{Float64}:
 1.0
 1.0
 3.0
 3.0
 6.0

julia> A = [1 2 3; 4 5 6];

julia> B = similar(A);

julia> accumulate!(-, B, A, dims=1)
2×3 Matrix{Int64}:
  1   2   3
 -3  -3  -3

julia> accumulate!(*, B, A, dims=2, init=10)
2×3 Matrix{Int64}:
 10   20    60
 40  200  1200
```
