```julia
lowrankupdowndate!(F::CHOLMOD.Factor, C::Sparse, update::Cint)
```

`LDLt` または `LLt` の分解 `F` を、`A` の `A ± C*C'` 分解に更新します。

疎性を保持する分解を使用する場合、つまり `L*L' == P*A*P'` の場合、新しい因子は `L*L' == P*A*P' + C'*C` になります。

`update`: `Cint(1)` は `A + CC'` 用、`Cint(0)` は `A - CC'` 用
