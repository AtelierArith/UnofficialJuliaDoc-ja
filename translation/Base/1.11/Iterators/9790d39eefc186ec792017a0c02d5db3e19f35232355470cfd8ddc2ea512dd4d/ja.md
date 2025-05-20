```
drop(iter, n)
```

最初の `n` 要素を除いたすべての要素を生成するイテレータです。

# 例

```jldoctest
julia> a = 1:2:11
1:2:11

julia> collect(a)
6-element Vector{Int64}:
  1
  3
  5
  7
  9
 11

julia> collect(Iterators.drop(a,4))
2-element Vector{Int64}:
  9
 11
```
