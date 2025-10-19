```julia
setdiff(s, itrs...)
```

`s`の要素のうち、`itrs`のいずれかに含まれない要素の集合を構築します。配列の順序を維持します。

[`setdiff!`](@ref)、[`union`](@ref)、および[`intersect`](@ref)も参照してください。

# 例

```jldoctest
julia> setdiff([1,2,3], [3,4,5])
2-element Vector{Int64}:
 1
 2
```
