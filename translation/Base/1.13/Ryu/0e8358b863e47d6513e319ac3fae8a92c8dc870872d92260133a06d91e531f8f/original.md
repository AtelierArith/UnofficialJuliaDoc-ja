```julia
Ryu.umul256_hi(a::UInt128, bHi::UInt64, bLo::UInt64)::UInt128
```

Compute `pHi = (a*b)>>128` where `b = bLo + bHi<<64`.
