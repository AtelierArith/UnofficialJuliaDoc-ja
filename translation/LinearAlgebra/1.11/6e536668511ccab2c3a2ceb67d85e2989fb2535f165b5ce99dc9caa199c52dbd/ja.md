```
diagind(M::AbstractMatrix, k::Integer = 0, indstyle::IndexStyle = IndexLinear())
diagind(M::AbstractMatrix, indstyle::IndexStyle = IndexLinear())
```

行列 `M` の `k` 番目の対角線のインデックスを与える `AbstractRange`。オプションで、返される範囲のタイプを決定するインデックススタイルを指定できます。`indstyle` が `IndexLinear` (デフォルト) の場合、これは `AbstractRange{Integer}` を返します。一方、`indstyle` が `IndexCartesian` の場合、これは `AbstractRange{CartesianIndex{2}}` を返します。

`k` が指定されていない場合、`0` (主対角線に対応) と見なされます。

参照: [`diag`](@ref), [`diagm`](@ref), [`Diagonal`](@ref).

# 例

```jldoctest
julia> A = [1 2 3; 4 5 6; 7 8 9]
3×3 Matrix{Int64}:
 1  2  3
 4  5  6
 7  8  9

julia> diagind(A, -1)
2:4:6

julia> diagind(A, IndexCartesian())
StepRangeLen(CartesianIndex(1, 1), CartesianIndex(1, 1), 3)
```

!!! compat "Julia 1.11"
    `IndexStyle` を指定するには、少なくとも Julia 1.11 が必要です。

