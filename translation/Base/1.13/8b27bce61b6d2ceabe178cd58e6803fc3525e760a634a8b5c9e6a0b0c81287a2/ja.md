```julia
<<(x, n)
```

左ビットシフト演算子、`x << n`。`n >= 0`の場合、結果は`x`を左に`n`ビットシフトし、`0`で埋めたものです。これは`x * 2^n`と同等です。`n < 0`の場合、これは`x >> -n`と同等です。

# Examples

```jldoctest
julia> Int8(3) << 2
12

julia> bitstring(Int8(3))
"00000011"

julia> bitstring(Int8(12))
"00001100"
```

[`>>`](@ref)、[`>>>`](@ref)、[`exp2`](@ref)、[`ldexp`](@ref)も参照してください。
