```
det_bareiss!(M)
```

Calculates the determinant of a matrix using the [Bareiss Algorithm](https://en.wikipedia.org/wiki/Bareiss_algorithm) using inplace operations.

# Examples

```jldoctest
julia> M = [1 0; 2 2]
2×2 Matrix{Int64}:
 1  0
 2  2

julia> LinearAlgebra.det_bareiss!(M)
2
```
