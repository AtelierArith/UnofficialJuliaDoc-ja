```julia
givens(A::AbstractArray, i1::Integer, i2::Integer, j::Integer) -> (G::Givens, r)
```

Computes the Givens rotation `G` and scalar `r` such that the result of the multiplication

```julia
B = G*A
```

has the property that

```julia
B[i1,j] = r
B[i2,j] = 0
```

See also [`LinearAlgebra.Givens`](@ref).
