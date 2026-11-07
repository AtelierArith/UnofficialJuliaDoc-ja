```julia
FilteringRF(f, rf) -> rf′
```

フィルタリングを行う縮約関数 `rf′(acc, x) = f(x) ? rf(acc, x) : acc` を作成します。
