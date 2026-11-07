```julia
Ryu.umul256(a::UInt128, bHi::UInt64, bLo::UInt64)::Tuple{UInt128, UInt128}
```

`b = bLo + bHi<<64` の場合に `p = a*b` を計算し、結果を `p = pLo + pHi<<128` の形式で `pLo, pHi` として返します。
