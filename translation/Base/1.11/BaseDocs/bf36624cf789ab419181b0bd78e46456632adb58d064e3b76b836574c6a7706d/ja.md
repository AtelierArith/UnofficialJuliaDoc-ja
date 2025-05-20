```
Int128 <: Signed <: Integer
```

128ビット符号付き整数型。

このような整数は警告なしにオーバーフローするため、`typemax(Int128) + Int128(1) < 0` となります。

他に [`Int`](@ref Int64)、[`widen`](@ref)、[`BigInt`](@ref) も参照してください。
