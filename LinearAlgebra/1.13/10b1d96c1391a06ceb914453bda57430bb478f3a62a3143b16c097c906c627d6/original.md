```julia
givens(x::AbstractVector, i1::Integer, i2::Integer) -> (G::Givens, r)
```

Computes the Givens rotation `G` and scalar `r` such that the result of the multiplication

```julia
B = G*x
```

has the property that

```julia
B[i1] = r
B[i2] = 0
```

See also [`LinearAlgebra.Givens`](@ref).
