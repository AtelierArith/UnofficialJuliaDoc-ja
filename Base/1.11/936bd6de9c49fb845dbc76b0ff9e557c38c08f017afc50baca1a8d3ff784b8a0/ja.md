```
findmin(A; dims) -> (minval, index)
```

配列入力に対して、指定された次元における最小値とそのインデックスを返します。`NaN`は、`missing`を除くすべての値よりも小さいと見なされます。

# 例

```jldoctest
julia> A = [1.0 2; 3 4]
2×2 Matrix{Float64}:
 1.0  2.0
 3.0  4.0

julia> findmin(A, dims=1)
([1.0 2.0], CartesianIndex{2}[CartesianIndex(1, 1) CartesianIndex(1, 2)])

julia> findmin(A, dims=2)
([1.0; 3.0;;], CartesianIndex{2}[CartesianIndex(1, 1); CartesianIndex(2, 1);;])
```
