```julia
isxdigit(c::AbstractChar)::Bool
```

文字が有効な16進数の数字かどうかを判定します。標準の`x`プレフィックスに含まれる`0x`は対象外です。

# Examples

```jldoctest
julia> isxdigit('a')
true

julia> isxdigit('x')
false
```
