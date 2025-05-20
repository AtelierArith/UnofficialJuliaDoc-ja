```
lowrankupdowndate!(F::CHOLMOD.Factor, C::Sparse, update::Cint)
```

`A`の`LDLt`または`LLt`因子分解`F`を`A ± C*C'`の因子分解に更新します。

スパース性を保持する因子分解が使用されている場合、すなわち`L*L' == P*A*P'`であれば、新しい因子は`L*L' == P*A*P' + C'*C`になります。

`update`: `Cint(1)`は`A + CC'`、`Cint(0)`は`A - CC'`です。
