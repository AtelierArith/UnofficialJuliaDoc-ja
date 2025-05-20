```
transpose(F::Factorization)
```

因子分解 `F` の遅延転置。デフォルトでは [`TransposeFactorization`](@ref) を返しますが、実数の `eltype` を持つ `Factorization` の場合は [`AdjointFactorization`](@ref) を返します。
