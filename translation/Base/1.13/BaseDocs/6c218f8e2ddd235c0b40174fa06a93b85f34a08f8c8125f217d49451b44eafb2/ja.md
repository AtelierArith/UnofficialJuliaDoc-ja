```julia
Int16 <: Signed <: Integer
```

16ビット符号付き整数型。

`n ∈ -32768:32767` の数値を表します。このような整数は警告なしにオーバーフローするため、`typemax(Int16) + Int16(1) < 0` であることに注意してください。

関連項目: [`Int`](@ref Int64)、[`widen`](@ref)、[`BigInt`](@ref)。
