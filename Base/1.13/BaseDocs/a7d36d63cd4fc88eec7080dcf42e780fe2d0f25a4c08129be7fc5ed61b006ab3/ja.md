```julia
Int128 <: Signed <: Integer
```

128ビット符号付き整数型。

この型の整数は警告なしにオーバーフローするため、`typemax(Int128) + Int128(1) < 0`。

関連項目: [`Int`](@ref Int64)、[`widen`](@ref)、[`BigInt`](@ref)。
