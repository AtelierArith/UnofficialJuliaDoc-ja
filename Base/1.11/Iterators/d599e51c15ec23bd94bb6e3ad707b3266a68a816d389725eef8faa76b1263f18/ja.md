```
takewhile(pred, iter)
```

`iter`から要素を生成するイテレータで、述語`pred`が真である限り要素を生成し、その後はすべての要素をドロップします。

!!! compat "Julia 1.4"
    この関数は少なくともJulia 1.4が必要です。


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
