```
deleteat!(a::Vector, i::Integer)
```

指定された `i` のアイテムを削除し、修正された `a` を返します。後続のアイテムは、結果として生じる隙間を埋めるためにシフトされます。

参照: [`keepat!`](@ref), [`delete!`](@ref), [`popat!`](@ref), [`splice!`](@ref)。

# 例

```jldoctest
julia> deleteat!([6, 5, 4, 3, 2, 1], 2)
5-element Vector{Int64}:
 6
 4
 3
 2
 1
```
