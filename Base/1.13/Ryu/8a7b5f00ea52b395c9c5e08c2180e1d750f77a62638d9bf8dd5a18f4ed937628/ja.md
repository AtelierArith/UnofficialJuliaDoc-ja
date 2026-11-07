```julia
Ryu.pow5bits(e)
```

`e == 0 ? 1 : ceil(log2(5^e))`を計算します。これは、`Int32`の算術演算で`e < 3529`を実行する場合に有効です。
