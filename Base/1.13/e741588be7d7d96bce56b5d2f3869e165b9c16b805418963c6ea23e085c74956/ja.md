```julia
FlatteningRF(rf) -> rf′
```

`rf′(acc, x) = foldl(rf, x; init=acc)`とおおむね同等の、平坦化を行う縮約関数を作成します。
