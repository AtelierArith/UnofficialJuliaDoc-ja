```julia
MappingRF(f, rf) -> rf′
```

`rf′(acc, x) = rf(acc, f(x))` を簡約するマッピング還元関数を作成します。
