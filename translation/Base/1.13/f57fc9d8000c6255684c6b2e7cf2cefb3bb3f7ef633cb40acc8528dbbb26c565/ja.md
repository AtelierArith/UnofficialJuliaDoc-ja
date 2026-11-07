```julia
prevind(A, i)
```

`A` 内で `i` より前にあるインデックスを返します。整数 `i` の場合、返されるインデックスは多くの場合 `i - 1` と同じです。この関数は、汎用コードで役立つことがあります。

!!! warning
    返されるインデックスは範囲外になる可能性があります。[`checkbounds`](@ref) の使用を検討してください。


関連項目: [`nextind`](@ref)。

# Examples

```jldoctest
julia> x = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> prevind(x, 4) # valid result
3

julia> prevind(x, 1) # invalid result
0

julia> prevind(x, CartesianIndex(2, 2)) # valid result
CartesianIndex(1, 2)

julia> prevind(x, CartesianIndex(1, 1)) # invalid result
CartesianIndex(2, 0)
```
