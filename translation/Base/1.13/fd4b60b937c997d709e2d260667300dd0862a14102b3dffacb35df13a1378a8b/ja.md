```julia
bitstring(n)
```

プリミティブ型のビット表現を文字列で示します（ビッグエンディアン、つまり最上位ビットが先頭）。

関連項目: [`count_ones`](@ref)、[`count_zeros`](@ref)、[`digits`](@ref)。

# Examples

```jldoctest
julia> bitstring(Int32(4))
"00000000000000000000000000000100"

julia> bitstring(2.2)
"0100000000000001100110011001100110011001100110011001100110011010"
```
