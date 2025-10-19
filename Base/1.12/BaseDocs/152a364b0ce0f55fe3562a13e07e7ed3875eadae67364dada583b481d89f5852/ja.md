```julia
Int16 <: Signed <: Integer
```

16ビット符号付き整数型。

`n ∈ -32768:32767` の数を表します。このような整数は警告なしにオーバーフローするため、`typemax(Int16) + Int16(1) < 0` となります。

他に [`Int`](@ref Int64)、[`widen`](@ref)、[`BigInt`](@ref) も参照してください。
