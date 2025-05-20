```
Int64 <: Signed <: Integer
```

64ビット符号付き整数型。

このような整数は警告なしにオーバーフローするため、`typemax(Int64) + Int64(1) < 0` となります。

関連情報としては [`Int`](@ref Int64)、[`widen`](@ref)、[`BigInt`](@ref) があります。
