```julia
findnext(A, i)
```

`A`の`true`要素の`i`以降の次のインデックスを見つけるか、見つからなければ`nothing`を返します。

インデックスは[`keys(A)`](@ref)および[`pairs(A)`](@ref)によって返されるものと同じ型です。

# 例

```jldoctest
julia> A = [false, false, true, false]
4-element Vector{Bool}:
 0
 0
 1
 0

julia> findnext(A, 1)
3

julia> findnext(A, 4) # nothingを返しますが、REPLには表示されません

julia> A = [false false; true false]
2×2 Matrix{Bool}:
 0  0
 1  0

julia> findnext(A, CartesianIndex(1, 1))
CartesianIndex(2, 1)
```
