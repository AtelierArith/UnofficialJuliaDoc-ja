```
cumsum(itr)
```

イテレータの累積和。

他の関数を適用するには、[`accumulate`](@ref)を参照してください。

!!! compat "Julia 1.5"
    非配列イテレータに対する`cumsum`は、少なくともJulia 1.5が必要です。


# 例

```jldoctest
julia> cumsum(1:3)
3-element Vector{Int64}:
 1
 3
 6

julia> cumsum((true, false, true, false, true))
(1, 1, 2, 2, 3)

julia> cumsum(fill(1, 2) for i in 1:3)
3-element Vector{Vector{Int64}}:
 [1, 1]
 [2, 2]
 [3, 3]
```
