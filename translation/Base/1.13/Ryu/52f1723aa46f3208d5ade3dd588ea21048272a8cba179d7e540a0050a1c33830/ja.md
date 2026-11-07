```julia
Ryu.pow5split(T, i)
```

`floor(5^i/2^k)`を計算します。`k = pow5bits(i) - pow5_bitcount(T)`の場合、結果は`T`の2倍の幅を持つ符号なし整数です（つまり、`T == Float64`の場合は`UInt128`）。有効ビット数は`pow5_bitcount(T)`です。
