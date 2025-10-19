```julia
selectdim(A, d::Integer, i)
```

次元 `d` のインデックスが `i` に等しい `A` のすべてのデータのビューを返します。

`i` が位置 `d` にある場合、`view(A,:,:,...,i,:,:,...)` と同等です。

参照: [`eachslice`](@ref).

# 例

```jldoctest
julia> A = [1 2 3 4; 5 6 7 8]
2×4 Matrix{Int64}:
 1  2  3  4
 5  6  7  8

julia> selectdim(A, 2, 3)
2-element view(::Matrix{Int64}, :, 3) with eltype Int64:
 3
 7

julia> selectdim(A, 2, 3:4)
2×2 view(::Matrix{Int64}, :, 3:4) with eltype Int64:
 3  4
 7  8
```
