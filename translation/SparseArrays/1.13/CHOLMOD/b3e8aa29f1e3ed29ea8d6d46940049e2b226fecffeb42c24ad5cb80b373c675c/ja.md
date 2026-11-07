```julia
lowrankupdowndate!(F::CHOLMOD.Factor, C::Sparse, update::Cint)
```

`LDLt` または `LLt` の分解 `F` を、`A` の分解から `A ± C*C'` の分解へ更新します。

疎性を保つ分解を使用する場合、つまり `L*L' == P*A*P'` の場合、新しい因子は `L*L' == P*A*P' + C'*C` になります。

`update`: `Cint(1)` は `A + CC'` に対して、`Cint(0)` は `A - CC'` に対して使用します。
