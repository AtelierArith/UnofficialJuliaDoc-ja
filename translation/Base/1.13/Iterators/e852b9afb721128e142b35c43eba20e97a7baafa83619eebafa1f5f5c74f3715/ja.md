```julia
dropwhile(pred, iter)
```

述語 `pred` が真である間、`iter` から要素を取り除き、その後はすべての要素を返すイテレータです。

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

julia> collect(Iterators.dropwhile(<(3),s))
3-element Vector{Int64}:
 3
 4
 5
```
