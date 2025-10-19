```julia
Int32 <: Signed <: Integer
```

32ビット符号付き整数型。

このような整数は警告なしにオーバーフローするため、`typemax(Int32) + Int32(1) < 0` となります。

関連項目としては [`Int`](@ref Int64)、[`widen`](@ref)、[`BigInt`](@ref) があります。
