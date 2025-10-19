```julia
Int128 <: Signed <: Integer
```

128ビット符号付き整数型。

このような整数は警告なしにオーバーフローするため、`typemax(Int128) + Int128(1) < 0` となります。

関連項目として [`Int`](@ref Int64)、[`widen`](@ref)、[`BigInt`](@ref) を参照してください。
