```julia
stack(iter; [dims])
```

同じサイズの配列（または他の反復可能なオブジェクト）のコレクションを、1つ以上の新しい次元に沿って配置することによって、1つの大きな配列に結合します。

デフォルトでは、要素の軸が最初に配置され、`size(result) = (size(first(iter))..., size(iter)...)` となります。これは [`Iterators.flatten`](@ref)`(iter)` と同じ順序の要素を持ちます。

キーワード `dims::Integer` を使用すると、代わりに `iter` の `i` 番目の要素がスライス [`selectdim`](@ref)`(result, dims, i)` となり、`size(result, dims) == length(iter)` になります。この場合、`stack` は同じ `dims` を持つ [`eachslice`](@ref) の動作を逆にします。

さまざまな [`cat`](@ref) 関数も配列を結合します。ただし、これらはすべて配列の既存の（おそらく自明な）次元を拡張するのに対し、配列を新しい次元に沿って配置することはありません。また、配列を単一のコレクションではなく、別々の引数として受け取ります。

!!! compat "Julia 1.9"
    この関数は少なくとも Julia 1.9 を必要とします。


# 例

```jldoctest
julia> vecs = (1:2, [30, 40], Float32[500, 600]);

julia> mat = stack(vecs)
2×3 Matrix{Float32}:
 1.0  30.0  500.0
 2.0  40.0  600.0

julia> mat == hcat(vecs...) == reduce(hcat, collect(vecs))
true

julia> vec(mat) == vcat(vecs...) == reduce(vcat, collect(vecs))
true

julia> stack(zip(1:4, 10:99))  # 任意の反復可能なオブジェクトの反復子を受け入れます
2×4 Matrix{Int64}:
  1   2   3   4
 10  11  12  13

julia> vec(ans) == collect(Iterators.flatten(zip(1:4, 10:99)))
true

julia> stack(vecs; dims=1)  # どの cat 関数とも異なり、vecs[1] の 1 番目の軸は結果の 2 番目の軸です
3×2 Matrix{Float32}:
   1.0    2.0
  30.0   40.0
 500.0  600.0

julia> x = rand(3,4);

julia> x == stack(eachcol(x)) == stack(eachrow(x), dims=1)  # eachslice の逆
true
```

高次元の例:

```jldoctest
julia> A = rand(5, 7, 11);

julia> E = eachslice(A, dims=2);  # 行列のベクトル

julia> (element = size(first(E)), container = size(E))
(element = (5, 11), container = (7,))

julia> stack(E) |> size
(5, 11, 7)

julia> stack(E) == stack(E; dims=3) == cat(E...; dims=3)
true

julia> A == stack(E; dims=2)
true

julia> M = (fill(10i+j, 2, 3) for i in 1:5, j in 1:7);

julia> (element = size(first(M)), container = size(M))
(element = (2, 3), container = (5, 7))

julia> stack(M) |> size  # すべての次元を保持
(2, 3, 5, 7)

julia> stack(M; dims=1) |> size  # dims=1 に沿った vec(container)
(35, 2, 3)

julia> hvcat(5, M...) |> size  # hvcat は行列を隣接させます
(14, 15)
```
