```julia
ordschur!(F::Schur, select::Union{Vector{Bool},BitVector}) -> F::Schur
```

Same as [`ordschur`](@ref) but overwrites the factorization `F`.
