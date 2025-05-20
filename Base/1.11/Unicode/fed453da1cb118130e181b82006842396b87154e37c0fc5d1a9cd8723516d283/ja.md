```
isspace(c::AbstractChar) -> Bool
```

文字が任意の空白文字であるかどうかをテストします。ASCII文字 '\t', '\n', '\v', '\f', '\r', および ' '、Latin-1文字 U+0085、そしてUnicodeカテゴリZsの文字を含みます。

# 例

```jldoctest
julia> isspace('\n')
true

julia> isspace('\r')
true

julia> isspace(' ')
true

julia> isspace('\x20')
true
```
