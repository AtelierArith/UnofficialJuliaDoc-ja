```julia
stride(A, k::Integer)
```

次元 `k` における隣接要素間のメモリ上の距離（要素数）を返します。

関連項目: [`strides`](@ref).

# Examples

```jldoctest
julia> A = fill(1, (3,4,5));

julia> stride(A,2)
3

julia> stride(A,3)
12
```
