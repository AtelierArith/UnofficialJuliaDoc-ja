```julia
^(b::Number, A::AbstractMatrix)
```

Matrix exponential, equivalent to $\exp(\log(b)A)$.

!!! compat "Julia 1.1"
    Support for raising `Irrational` numbers (like `ℯ`) to a matrix was added in Julia 1.1.


# Examples

```jldoctest
julia> 2^[1 2; 0 3]
2×2 Matrix{Float64}:
 2.0  6.0
 0.0  8.0

julia> ℯ^[1 2; 0 3]
2×2 Matrix{Float64}:
 2.71828  17.3673
 0.0      20.0855
```
