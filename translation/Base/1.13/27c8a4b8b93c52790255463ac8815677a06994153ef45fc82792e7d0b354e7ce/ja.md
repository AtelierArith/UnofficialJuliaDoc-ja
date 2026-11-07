```julia
insertdims(A; dims)
```

[`dropdims`](@ref) の逆関数です。`dims` の各次元に新しいサイズ1の次元を追加した配列を返します。

次元の重複は許可されません。また、`dims` の最大の要素は `ndims(A) + length(dims)` 以下でなければなりません。

結果は `A` と同じ基底データを共有します。そのため、結果が変更可能であるのは `A` が変更可能な場合に限られ、一方の要素を設定すると、もう一方の値も変わります。

関連項目: [`dropdims`](@ref)、[`reshape`](@ref)、[`vec`](@ref)。

# Examples

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

