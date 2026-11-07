```julia
Ryu.umul256_hi(a::UInt128, bHi::UInt64, bLo::UInt64)::UInt128
```

`pHi = (a*b)>>128` を `b = bLo + bHi<<64` で計算します。
