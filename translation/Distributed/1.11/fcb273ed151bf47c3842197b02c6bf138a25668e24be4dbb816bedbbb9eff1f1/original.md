```
head_and_tail(c, n) -> head, tail
```

Return `head`: the first `n` elements of `c`; and `tail`: an iterator over the remaining elements.

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
