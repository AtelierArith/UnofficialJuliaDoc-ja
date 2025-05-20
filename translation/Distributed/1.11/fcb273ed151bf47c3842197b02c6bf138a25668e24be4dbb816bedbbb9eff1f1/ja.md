```
head_and_tail(c, n) -> head, tail
```

`head`を返します：`c`の最初の`n`要素；および`tail`：残りの要素に対するイテレータ。

```jldoctest
julia> b, c = Distributed.head_and_tail(1:10, 3)
([1, 2, 3], Base.Iterators.Rest{UnitRange{Int64}, Int64}(1:10, 3))

julia> collect(c)
7-element Vector{Int64}:
  4
  5
  6
  7
  8
  9
 10
```
