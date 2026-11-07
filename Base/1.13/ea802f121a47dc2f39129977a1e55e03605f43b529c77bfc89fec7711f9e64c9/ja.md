```julia
unsigned(x)
```

数値を符号なし整数に変換します。引数が符号付きの場合、負の値かどうかを確認せずに符号なしとして再解釈します。

関連項目: [`signed`](@ref)、[`sign`](@ref)、[`signbit`](@ref)。

# Examples

```jldoctest
julia> unsigned(-2)
0xfffffffffffffffe

julia> unsigned(Int8(2))
0x02

julia> typeof(ans)
UInt8

julia> signed(unsigned(-2))
-2
```
