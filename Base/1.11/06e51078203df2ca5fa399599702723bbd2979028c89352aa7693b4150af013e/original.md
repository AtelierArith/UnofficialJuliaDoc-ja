```
all(A; dims)
```

Test whether all values along the given dimensions of an array are `true`.

# Examples

```jldoctest
julia> A = [true false; true true]
2×2 Matrix{Bool}:
 1  0
 1  1

julia> all(A, dims=1)
1×2 Matrix{Bool}:
 1  0

julia> all(A, dims=2)
2×1 Matrix{Bool}:
 0
 1
```
