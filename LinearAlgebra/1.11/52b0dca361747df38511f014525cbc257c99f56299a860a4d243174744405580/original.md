```
^(A::AbstractMatrix, p::Number)
```

Matrix power, equivalent to $\exp(p\log(A))$

# Examples

```jldoctest
julia> [1 2; 0 3]^3
2×2 Matrix{Int64}:
 1  26
 0  27
```
