```julia
Base.mul_with_overflow(x, y) -> (r, f)
```

`r = x*y`を計算します。フラグ`f`は、オーバーフローが発生したかどうかを示します。
