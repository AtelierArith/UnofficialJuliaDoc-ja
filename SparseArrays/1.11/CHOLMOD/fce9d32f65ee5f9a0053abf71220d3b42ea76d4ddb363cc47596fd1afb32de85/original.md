```
lowrankupdowndate!(F::CHOLMOD.Factor, C::Sparse, update::Cint)
```

Update an `LDLt` or `LLt` Factorization `F` of `A` to a factorization of `A ± C*C'`.

If sparsity preserving factorization is used, i.e. `L*L' == P*A*P'` then the new factor will be `L*L' == P*A*P' + C'*C`

`update`: `Cint(1)` for `A + CC'`, `Cint(0)` for `A - CC'`
