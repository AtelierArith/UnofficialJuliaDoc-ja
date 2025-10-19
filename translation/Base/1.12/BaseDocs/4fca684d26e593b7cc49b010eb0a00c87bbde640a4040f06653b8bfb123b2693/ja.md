```julia
Int8 <: Signed <: Integer
```

8ビット符号付き整数型。

`n ∈ -128:127` の数を表します。このような整数は警告なしにオーバーフローするため、`typemax(Int8) + Int8(1) < 0` となります。

他に [`Int`](@ref Int64)、[`widen`](@ref)、[`BigInt`](@ref) も参照してください。
