```julia
findmin(A; dims) -> (minval, index)
```

配列を入力として受け取り、指定された次元における最小値とそのインデックスを返します。`NaN` は、`missing` を除くすべての値より小さいものとして扱われます。

# Examples

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
