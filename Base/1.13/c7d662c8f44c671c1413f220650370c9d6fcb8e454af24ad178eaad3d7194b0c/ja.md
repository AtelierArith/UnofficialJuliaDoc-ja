```julia
extrema(A::AbstractArray; dims) -> Array{Tuple}
```

指定された次元に沿って、配列の最小要素と最大要素を計算します。

関連項目: [`minimum`](@ref)、[`maximum`](@ref)、[`extrema!`](@ref)。

# Examples

```jldoctest
julia> A = reshape(Vector(1:2:16), (2,2,2))
2×2×2 Array{Int64, 3}:
[:, :, 1] =
 1  5
 3  7

[:, :, 2] =
  9  13
 11  15

julia> extrema(A, dims = (1,2))
1×1×2 Array{Tuple{Int64, Int64}, 3}:
[:, :, 1] =
 (1, 7)

[:, :, 2] =
 (9, 15)
```
