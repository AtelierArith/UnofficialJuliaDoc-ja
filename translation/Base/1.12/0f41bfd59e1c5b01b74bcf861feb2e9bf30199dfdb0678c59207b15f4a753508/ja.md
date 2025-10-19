```julia
findmax(A; dims) -> (maxval, index)
```

配列入力の場合、指定された次元における最大値とインデックスを返します。`NaN`は`missing`を除くすべての値よりも大きいと見なされます。

# 例

```jldoctest
julia> A = [1.0 2; 3 4]
2×2 Matrix{Float64}:
 1.0  2.0
 3.0  4.0

julia> findmax(A, dims=1)
([3.0 4.0], CartesianIndex{2}[CartesianIndex(2, 1) CartesianIndex(2, 2)])

julia> findmax(A, dims=2)
([2.0; 4.0;;], CartesianIndex{2}[CartesianIndex(1, 2); CartesianIndex(2, 2);;])
```
