```julia
cumsum(itr)
```

イテレータの累積和。

[`accumulate`](@ref)を使うと、`+`以外の関数を適用できます。

!!! compat "Julia 1.5"
    配列以外のイテレータに対する`cumsum`の使用には、Julia 1.5以降が必要です。


# Examples

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
