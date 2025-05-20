```
prevind(A, i)
```

`A`の`i`の前のインデックスを返します。返されるインデックスは、整数`i`に対してしばしば`i - 1`と同等です。この関数は、汎用コードに役立ちます。

!!! warning
    返されるインデックスは範囲外である可能性があります。[`checkbounds`](@ref)の使用を検討してください。


関連情報: [`nextind`](@ref).

# 例

```jldoctest
julia> x = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> prevind(x, 4) # 有効な結果
3

julia> prevind(x, 1) # 無効な結果
0

julia> prevind(x, CartesianIndex(2, 2)) # 有効な結果
CartesianIndex(1, 2)

julia> prevind(x, CartesianIndex(1, 1)) # 無効な結果
CartesianIndex(2, 0)
```
