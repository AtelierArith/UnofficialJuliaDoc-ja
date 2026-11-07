```julia
Test.set_rng!(ts::AbstractTestSet, rng::AbstractRNG)::AbstractRNG
```

入力テストセット `ts` に関連付けられたグローバル乱数生成器（RNG）を `rng` に設定します。RNG が関連付けられていない場合は何もしません。いずれの場合も、入力 `rng` を必ず返します。
