```
getindex(type[, elements...])
```

指定された型の1次元配列を構築します。これは通常、`Type[]`という構文で呼び出されます。要素の値は`Type[a,b,c,...]`を使用して指定できます。

# 例

```jldoctest
julia> Int8[1, 2, 3]
3-element Vector{Int8}:
 1
 2
 3

julia> getindex(Int8, 1, 2, 3)
3-element Vector{Int8}:
 1
 2
 3
```
