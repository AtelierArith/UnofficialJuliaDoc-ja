```julia
Ryu.pow5invsplit(T, i)
```

`floor(2^k/5^i)+1`を計算します。ここで、`k = pow5bits(i) - 1 + pow5_inv_bitcount(T)`です。結果は、`T`の2倍の幅を持つ符号なし整数です（つまり、`T == Float64`の場合は`UInt128`）。有効ビット数は`pow5_inv_bitcount(T)`です。
