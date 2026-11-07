```julia
isxdigit(c::AbstractChar)::Bool
```

文字が有効な16進数の数字かどうかを判定します。`x`（標準の`0x`プレフィックスなど）は含まれないことに注意してください。

# Examples

```jldoctest
julia> isxdigit('a')
true

julia> isxdigit('x')
false
```
