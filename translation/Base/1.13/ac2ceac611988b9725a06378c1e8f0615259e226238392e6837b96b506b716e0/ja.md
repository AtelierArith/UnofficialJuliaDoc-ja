```julia
>>(x, n)
```

右ビットシフト演算子 `x >> n`。`n >= 0` の場合、結果は `x` を `n` ビット右にシフトした値です。`x >= 0` の場合は `0` で、`x < 0` の場合は `1` で埋め、`x` の符号を保持します。これは `fld(x, 2^n)` と同等です。`n < 0` の場合、これは `x << -n` と同等です。

# Examples

```jldoctest
julia> Int8(13) >> 2
3

julia> bitstring(Int8(13))
"00001101"

julia> bitstring(Int8(3))
"00000011"

julia> Int8(-14) >> 2
-4

julia> bitstring(Int8(-14))
"11110010"

julia> bitstring(Int8(-4))
"11111100"
```

[`>>>`](@ref)、[`<<`](@ref) も参照してください。
