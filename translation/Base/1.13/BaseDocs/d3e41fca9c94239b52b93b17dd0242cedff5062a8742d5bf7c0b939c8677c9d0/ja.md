```julia
Int32 <: Signed <: Integer
```

32ビット符号付き整数型。

この型の整数は警告なしにオーバーフローするため、`typemax(Int32) + Int32(1) < 0` に注意してください。

[`Int`](@ref Int64)、[`widen`](@ref)、[`BigInt`](@ref) も参照してください。
