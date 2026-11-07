```julia
nextind(A, i)
```

`i` の後のインデックスを `A` で返します。整数 `i` の場合、返されるインデックスは `i + 1` と等しくなることがよくあります。この関数は、汎用コードで役立つ場合があります。

!!! warning
    返されるインデックスは範囲外になる可能性があります。[`checkbounds`](@ref) の使用を検討してください。


関連項目: [`prevind`](@ref)。

# Examples

```jldoctest
julia> x = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> nextind(x, 1) # valid result
2

julia> nextind(x, 4) # invalid result
5

julia> nextind(x, CartesianIndex(1, 1)) # valid result
CartesianIndex(2, 1)

julia> nextind(x, CartesianIndex(2, 2)) # invalid result
CartesianIndex(1, 3)
```
