```julia
stack(iter; [dims])
```

同じサイズの配列（またはその他の反復可能オブジェクト）のコレクションを、新しい次元を1つ以上追加して並べることで、より大きな配列にまとめます。

デフォルトでは、要素の軸が先に配置され、`size(result) = (size(first(iter))..., size(iter)...)`となります。これは、[`Iterators.flatten`](@ref)`(iter)`と同じ要素順になります。

キーワード`dims::Integer`を指定すると、代わりに`iter`の`i`番目の要素がスライス[`selectdim`](@ref)`(result, dims, i)`となり、`size(result, dims) == length(iter)`となります。この場合、`stack`は、同じ`dims`を指定した[`eachslice`](@ref)の逆の操作を行います。

[`cat`](@ref)の各種関数も配列を結合します。ただし、これらの関数は配列を新しい次元に沿って配置するのではなく、既存の（場合によっては自明な）次元を拡張します。また、単一のコレクションではなく、個別の引数として配列を受け取ります。

!!! compat "Julia 1.9"
    この関数を使用するには、Julia 1.9以降が必要です。


# Examples

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

julia> stack(zip(1:4, 10:99))  # accepts any iterators of iterators
2×4 Matrix{Int64}:
  1   2   3   4
 10  11  12  13

julia> vec(ans) == collect(Iterators.flatten(zip(1:4, 10:99)))
true

julia> stack(vecs; dims=1)  # unlike any cat function, 1st axis of vecs[1] is 2nd axis of result
3×2 Matrix{Float32}:
   1.0    2.0
  30.0   40.0
 500.0  600.0

julia> x = rand(3,4);

julia> x == stack(eachcol(x)) == stack(eachrow(x), dims=1)  # inverse of eachslice
true
```

高次元の例：

```jldoctest
julia> A = rand(5, 7, 11);

julia> E = eachslice(A, dims=2);  # a vector of matrices

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

julia> stack(M) |> size  # keeps all dimensions
(2, 3, 5, 7)

julia> stack(M; dims=1) |> size  # vec(container) along dims=1
(35, 2, 3)

julia> hvcat(5, M...) |> size  # hvcat puts matrices next to each other
(14, 15)
```
