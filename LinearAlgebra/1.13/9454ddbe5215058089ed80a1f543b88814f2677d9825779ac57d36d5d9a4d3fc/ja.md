```julia
transpose(F::Factorization)
```

因子分解 `F` の遅延転置です。デフォルトでは [`TransposeFactorization`](@ref) を返します。ただし、実数の `eltype` を持つ `Factorization` の場合は、[`AdjointFactorization`](@ref) を返します。
