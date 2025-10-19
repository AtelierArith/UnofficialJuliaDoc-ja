```julia
insertdims(A; dims)
```

[`dropdims`](@ref) の逆; `dims` のすべての次元に新しい単一次元を持つ配列を返します。

繰り返しの次元は禁じられており、`dims` の最大エントリは `ndims(A) + length(dims)` 以下でなければなりません。

結果は `A` と同じ基礎データを共有し、したがって結果は `A` が可変である場合にのみ可変であり、一方の要素を設定すると他方の値が変更されます。

関連項目: [`dropdims`](@ref), [`reshape`](@ref), [`vec`](@ref).

# 例

```jldoctest
julia> x = [1 2 3; 4 5 6]
2×3 Matrix{Int64}:
 1  2  3
 4  5  6

julia> insertdims(x, dims=3)
2×3×1 Array{Int64, 3}:
[:, :, 1] =
 1  2  3
 4  5  6

julia> insertdims(x, dims=(1,2,5)) == reshape(x, 1, 1, 2, 3, 1)
true

julia> dropdims(insertdims(x, dims=(1,2,5)), dims=(1,2,5))
2×3 Matrix{Int64}:
 1  2  3
 4  5  6
```

!!! compat "Julia 1.12"
    Julia 1.12 以降が必要です。

