```julia
Ryu.umul256(a::UInt128, bHi::UInt64, bLo::UInt64)::Tuple{UInt128, UInt128}
```

`p = a*b` を `b = bLo + bHi<<64` で計算し、結果を `pLo, pHi` として返します。`p = pLo + pHi<<128`。
