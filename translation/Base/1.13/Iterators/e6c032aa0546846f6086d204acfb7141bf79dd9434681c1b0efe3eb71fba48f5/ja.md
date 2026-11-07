```julia
takewhile(pred, iter)
```

述語 `pred` が真である間、`iter` から要素を生成し、その後はすべての要素を破棄するイテレーターです。

!!! compat "Julia 1.4"
    この関数を使用するには、Julia 1.4 以降が必要です。


# Examples

```jldoctest
julia> s = collect(1:5)
5-element Vector{Int64}:
 1
 2
 3
 4
 5

julia> collect(Iterators.takewhile(<(3),s))
2-element Vector{Int64}:
 1
 2
```
