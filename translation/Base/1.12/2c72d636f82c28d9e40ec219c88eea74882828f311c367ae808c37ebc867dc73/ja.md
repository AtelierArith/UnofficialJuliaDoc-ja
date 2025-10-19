```julia
argmax(A; dims) -> indices
```

配列入力の場合、指定された次元にわたる最大要素のインデックスを返します。`NaN`は、`missing`を除くすべての値よりも大きいと見なされます。

# 例

```jldoctest
julia> A = [1.0 2; 3 4]
2×2 Matrix{Float64}:
 1.0  2.0
 3.0  4.0

julia> argmax(A, dims=1)
1×2 Matrix{CartesianIndex{2}}:
 CartesianIndex(2, 1)  CartesianIndex(2, 2)

julia> argmax(A, dims=2)
2×1 Matrix{CartesianIndex{2}}:
 CartesianIndex(1, 2)
 CartesianIndex(2, 2)
```
