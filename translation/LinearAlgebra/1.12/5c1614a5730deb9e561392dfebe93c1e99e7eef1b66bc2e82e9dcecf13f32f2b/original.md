```julia
givens(f::T, g::T, i1::Integer, i2::Integer) where {T} -> (G::Givens, r::T)
```

Computes the Givens rotation `G` and scalar `r` such that for any vector `x` where

```julia
x[i1] = f
x[i2] = g
```

the result of the multiplication

```julia
y = G*x
```

has the property that

```julia
y[i1] = r
y[i2] = 0
```

See also [`LinearAlgebra.Givens`](@ref).
