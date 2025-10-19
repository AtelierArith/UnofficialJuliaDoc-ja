```julia
dropwhile(pred, iter)
```

条件 `pred` が真である限り `iter` から要素をドロップし、その後はすべての要素を返すイテレータです。

!!! compat "Julia 1.4"
    この関数は少なくとも Julia 1.4 を必要とします。


# 例

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
