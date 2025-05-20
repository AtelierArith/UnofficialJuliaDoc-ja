```
Iterators.map(f, iterators...)
```

遅延マッピングを作成します。これは、`(f(args...) for args in zip(iterators...))`を書くための別の構文です。

!!! compat "Julia 1.6"
    この関数は少なくともJulia 1.6を必要とします。


# 例

```jldoctest
julia> collect(Iterators.map(x -> x^2, 1:3))
3-element Vector{Int64}:
 1
 4
 9
```
