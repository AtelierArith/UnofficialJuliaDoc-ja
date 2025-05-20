```
iscntrl(c::AbstractChar) -> Bool
```

文字が制御文字であるかどうかをテストします。制御文字は、UnicodeのLatin-1サブセットの非印刷文字です。

# 例

```jldoctest
julia> iscntrl('\x01')
true

julia> iscntrl('a')
false
```
