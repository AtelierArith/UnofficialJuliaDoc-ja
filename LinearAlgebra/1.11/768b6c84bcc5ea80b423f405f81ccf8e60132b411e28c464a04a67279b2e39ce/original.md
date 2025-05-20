```
transpose(F::Factorization)
```

Lazy transpose of the factorization `F`. By default, returns a [`TransposeFactorization`](@ref), except for `Factorization`s with real `eltype`, in which case returns an [`AdjointFactorization`](@ref).
