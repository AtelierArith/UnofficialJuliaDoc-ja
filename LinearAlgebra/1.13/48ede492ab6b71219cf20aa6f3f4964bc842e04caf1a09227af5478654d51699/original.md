```julia
logdet(M)
```

Logarithm of matrix determinant. Equivalent to `log(det(M))`, but may provide increased accuracy and avoids overflow/underflow.

# Examples

```jldoctest
julia> M = [1 0; 2 2]
2×2 Matrix{Int64}:
 1  0
 2  2

julia> logdet(M)
0.6931471805599453

julia> logdet(Matrix(I, 3, 3))
0.0
```
