```julia
vec(a::AbstractArray)::AbstractVector
```

配列 `a` を1次元の列ベクトルに変形します。すでに `AbstractVector` である場合は、`a` を返します。結果の配列は `a` と同じ基になるデータを共有するため、変更可能なのは `a` が変更可能な場合に限られます。その場合、一方を変更すると、もう一方にも変更が反映されます。

# Examples

```jldoctest
julia> a = [1 2 3; 4 5 6]
2×3 Matrix{Int64}:
 1  2  3
 4  5  6

julia> vec(a)
6-element Vector{Int64}:
 1
 4
 2
 5
 3
 6

julia> vec(1:3)
1:3
```

関連項目: [`reshape`](@ref)、[`dropdims`](@ref)。
