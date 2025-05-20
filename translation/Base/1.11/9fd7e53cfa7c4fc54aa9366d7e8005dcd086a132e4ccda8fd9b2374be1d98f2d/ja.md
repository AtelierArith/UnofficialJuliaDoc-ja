```
extrema(A::AbstractArray; dims) -> Array{Tuple}
```

与えられた次元にわたって配列の最小および最大要素を計算します。

参照: [`minimum`](@ref), [`maximum`](@ref), [`extrema!`](@ref).

# 例

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
