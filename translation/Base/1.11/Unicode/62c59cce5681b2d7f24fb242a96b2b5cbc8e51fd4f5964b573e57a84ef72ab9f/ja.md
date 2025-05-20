```
ispunct(c::AbstractChar) -> Bool
```

文字がUnicodeの一般カテゴリ「句読点」に属するかどうかをテストします。つまり、カテゴリコードが「P」で始まる文字です。

# 例

```jldoctest
julia> ispunct('α')
false

julia> ispunct('/')
true

julia> ispunct(';')
true
```
