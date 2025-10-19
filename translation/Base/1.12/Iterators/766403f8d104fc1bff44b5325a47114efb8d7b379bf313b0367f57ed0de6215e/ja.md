```julia
takewhile(pred, iter)
```

条件 `pred` が真である限り `iter` から要素を生成するイテレータであり、その後はすべての要素をドロップします。

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

julia> collect(Iterators.takewhile(<(3),s))
2-element Vector{Int64}:
 1
 2
```
