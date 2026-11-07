```julia
>>>(x, n)
```

符号なし右ビットシフト演算子 `x >>> n`。`n >= 0`の場合、結果は `x` を `n` ビット右にシフトし、`0` で埋めた値です。`n < 0` の場合、これは `x << -n` と同等です。

[`Unsigned`](@ref) 整数型の場合、これは [`>>`](@ref) と同等です。[`Signed`](@ref) 整数型の場合、これは `signed(unsigned(x) >> n)` と同等です。

# Examples

```jldoctest
julia> Int8(-14) >>> 2
60

julia> bitstring(Int8(-14))
"11110010"

julia> bitstring(Int8(60))
"00111100"
```

[`BigInt`](@ref) は無限のサイズを持つものとして扱われるため、埋める必要はなく、これは [`>>`](@ref) と同等です。

[`>>`](@ref)、[`<<`](@ref) も参照してください。
