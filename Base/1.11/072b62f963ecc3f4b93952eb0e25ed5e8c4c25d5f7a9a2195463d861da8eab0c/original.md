```
all(p, A; dims)
```

Determine whether predicate `p` returns `true` for all elements along the given dimensions of an array.

# Examples

```jldoctest
julia> A = [1 -1; 2 2]
2×2 Matrix{Int64}:
 1  -1
 2   2

julia> all(i -> i > 0, A, dims=1)
1×2 Matrix{Bool}:
 1  0

julia> all(i -> i > 0, A, dims=2)
2×1 Matrix{Bool}:
 0
 1
```
