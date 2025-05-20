```
nextind(A, i)
```

`A`の`i`の後のインデックスを返します。返されるインデックスは、整数`i`の場合、しばしば`i + 1`に相当します。この関数は、汎用コードに役立ちます。

!!! warning
    返されるインデックスは範囲外である可能性があります。[`checkbounds`](@ref)の使用を検討してください。


関連情報: [`prevind`](@ref).

# 例

```jldoctest
julia> x = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> nextind(x, 1) # 有効な結果
2

julia> nextind(x, 4) # 無効な結果
5

julia> nextind(x, CartesianIndex(1, 1)) # 有効な結果
CartesianIndex(2, 1)

julia> nextind(x, CartesianIndex(2, 2)) # 無効な結果
CartesianIndex(1, 3)
```
