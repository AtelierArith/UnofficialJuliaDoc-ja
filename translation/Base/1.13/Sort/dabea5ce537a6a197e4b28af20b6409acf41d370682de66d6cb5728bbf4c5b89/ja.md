```julia
sortperm(A; alg::Base.Sort.Algorithm=Base.Sort.DEFAULT_UNSTABLE, lt=isless, by=identity, rev::Bool=false, order::Base.Order.Ordering=Base.Order.Forward, [dims::Integer])
```

指定された次元に沿って `A[I]` をソートした順序に並べる置換ベクトルまたは配列 `I` を返します。`A` の次元数が 1 より大きい場合は、キーワード引数 `dims` を指定する必要があります。順序の指定には、[`sort!`](@ref) と同じキーワードを使用します。ソートアルゴリズムが不安定な場合でも、置換は安定であることが保証されます。つまり、等しい要素のインデックスは昇順に並びます。

関連項目: [`sortperm!`](@ref)、[`partialsortperm`](@ref)、[`invperm`](@ref)、[`indexin`](@ref)。配列のスライスをソートする方法については、[`sortslices`](@ref) を参照してください。

!!! compat "Julia 1.9"
    `dims` を受け取るメソッドを使用するには、Julia 1.9 以降が必要です。


# Examples

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
