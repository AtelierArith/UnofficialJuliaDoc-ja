```julia
stride(A, k::Integer)
```

次元 `k` における隣接要素間のメモリ内の距離（要素数）を返します。

関連情報: [`strides`](@ref).

# 例

```jldoctest
julia> A = fill(1, (3,4,5));

julia> stride(A,2)
3

julia> stride(A,3)
12
```
