```julia
unsigned(x)
```

数値を符号なし整数に変換します。引数が符号付きの場合、負の値をチェックせずに符号なしとして再解釈されます。

関連: [`signed`](@ref), [`sign`](@ref), [`signbit`](@ref).

# 例

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
