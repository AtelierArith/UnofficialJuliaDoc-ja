```julia
isprint(c::AbstractChar) -> Bool
```

文字が印刷可能かどうかをテストします。スペースは含まれますが、制御文字は含まれません。

# 例

```jldoctest
julia> isprint('\x01')
false

julia> isprint('A')
true
```
