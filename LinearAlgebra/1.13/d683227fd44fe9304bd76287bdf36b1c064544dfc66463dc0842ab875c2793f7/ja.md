```julia
diagind(M::AbstractMatrix, k::Integer = 0, indstyle::IndexStyle = IndexLinear())
diagind(M::AbstractMatrix, indstyle::IndexStyle = IndexLinear())
diagind(::IndexStyle, m::Integer, n::Integer, k::Integer = 0)
diagind(m::Integer, n::Integer, k::Integer = 0)
```

行列の `k` 番目の対角線のインデックスを返す `AbstractRange` です。行列 `M` 自体、またはその次元 `m` と `n` を指定します。必要に応じて、返される範囲の型を決めるインデックススタイルも指定できます。`indstyle isa IndexLinear`（デフォルト）の場合、`AbstractRange{Integer}` を返します。一方、`indstyle isa IndexCartesian` の場合は、`AbstractRange{CartesianIndex{2}}` を返します。

`k` を指定しない場合は、`0`（主対角線に対応）とみなされます。

関連項目: [`diag`](@ref)、[`diagm`](@ref)、[`Diagonal`](@ref)。

# Examples

行列自体を `diagind` に渡すことができます。

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

または、次元 `m` と `n` を渡すと、`m×n` 行列の対角線を取得できます。

```jldoctest
julia> m, n = 5, 7
(5, 7)

julia> diagind(m, n, 2)
11:6:35

julia> diagind(IndexCartesian(), m, n)
StepRangeLen(CartesianIndex(1, 1), CartesianIndex(1, 1), 5)
```

!!! compat "Julia 1.11"
    `IndexStyle` を指定するには、Julia 1.11 以降が必要です。

