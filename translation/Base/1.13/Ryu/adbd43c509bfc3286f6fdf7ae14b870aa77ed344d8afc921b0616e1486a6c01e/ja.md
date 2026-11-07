```julia
Ryu.mulshiftmod1e9(m, mula, mulb, mulc, j)::UInt32
```

`(m * mul) >> j % 10^9` を `mul = mula + mulb<<64 + mulc<<128` で計算し、`j >= 128`。
