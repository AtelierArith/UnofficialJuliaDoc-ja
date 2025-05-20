```
isprint(c::AbstractChar) -> Bool
```

文字が印刷可能かどうかをテストします。スペースを含みますが、制御文字は含みません。

# 例

```jldoctest
julia> isprint('\x01')
false

julia> isprint('A')
true
```
