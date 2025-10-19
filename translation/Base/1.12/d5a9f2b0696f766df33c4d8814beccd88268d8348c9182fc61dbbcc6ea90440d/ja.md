```julia
vec(a::AbstractArray) -> AbstractVector
```

配列 `a` を一次元の列ベクトルとして再形成します。`a` がすでに `AbstractVector` の場合は `a` を返します。結果の配列は `a` と同じ基礎データを共有するため、`a` が可変である場合にのみ可変であり、その場合、一方を変更するともう一方も変更されます。

# 例

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

他にも [`reshape`](@ref), [`dropdims`](@ref) を参照してください。
