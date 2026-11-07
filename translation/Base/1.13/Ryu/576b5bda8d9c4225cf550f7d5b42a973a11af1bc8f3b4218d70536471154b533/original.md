```julia
Ryu.umul256(a::UInt128, bHi::UInt64, bLo::UInt64)::Tuple{UInt128, UInt128}
```

Compute `p = a*b` where `b = bLo + bHi<<64`, returning the result as `pLo, pHi` where `p = pLo + pHi<<128`.
