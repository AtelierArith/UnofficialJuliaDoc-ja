```julia
Test.get_rng(ts::AbstractTestSet)::Union{Nothing,AbstractRNG}
```

入力されたテストセット `ts` に関連付けられたグローバル乱数生成器（RNG）を返します。関連付けられた RNG がない場合は、`nothing` を返します。
