```
isxdigit(c::AbstractChar) -> Bool
```

文字が有効な16進数の桁であるかどうかをテストします。これは、標準の `0x` プレフィックスにある `x` は含まれないことに注意してください。

# 例

```jldoctest
julia> isxdigit('a')
true

julia> isxdigit('x')
false
```
