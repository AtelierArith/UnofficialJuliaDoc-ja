```julia
sortperm(A; alg::Base.Sort.Algorithm=Base.Sort.DEFAULT_UNSTABLE, lt=isless, by=identity, rev::Bool=false, order::Base.Order.Ordering=Base.Order.Forward, [dims::Integer])
```

配列 `A` を指定された次元でソートされた順序にするための置換ベクトルまたは配列 `I` を返します。`A` が複数の次元を持つ場合、`dims` キーワード引数を指定する必要があります。順序は [`sort!`](@ref) と同じキーワードを使用して指定されます。置換は、ソートアルゴリズムが不安定であっても安定であることが保証されており、等しい要素のインデックスは昇順で表示されます。

他にも [`sortperm!`](@ref)、[`partialsortperm`](@ref)、[`invperm`](@ref)、[`indexin`](@ref) を参照してください。配列のスライスをソートするには、[`sortslices`](@ref) を参照してください。

!!! compat "Julia 1.9"
    `dims` を受け入れるメソッドは、少なくとも Julia 1.9 が必要です。


# 例

```jldoctest
julia> v = [3, 1, 2];

julia> p = sortperm(v)
3-element Vector{Int64}:
 2
 3
 1

julia> v[p]
3-element Vector{Int64}:
 1
 2
 3

julia> A = [8 7; 5 6]
2×2 Matrix{Int64}:
 8  7
 5  6

julia> sortperm(A, dims = 1)
2×2 Matrix{Int64}:
 2  4
 1  3

julia> sortperm(A, dims = 2)
2×2 Matrix{Int64}:
 3  1
 2  4
```
