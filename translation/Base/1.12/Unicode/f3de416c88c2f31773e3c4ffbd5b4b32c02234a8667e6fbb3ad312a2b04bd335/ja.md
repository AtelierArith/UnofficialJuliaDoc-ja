```julia
ispunct(c::AbstractChar) -> Bool
```

文字がUnicodeの一般カテゴリ「句読点」に属するかどうかをテストします。つまり、カテゴリコードが「P」で始まる文字です。

!!! note
    この動作はCの`ispunct`関数とは異なります。


# 例

```jldoctest
julia> ispunct('α')
false

julia> ispunct('=')
false

julia> ispunct('/')
true

julia> ispunct(';')
true
```
