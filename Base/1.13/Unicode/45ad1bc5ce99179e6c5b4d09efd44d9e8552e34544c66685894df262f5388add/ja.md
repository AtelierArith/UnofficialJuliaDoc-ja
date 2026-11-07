```julia
isspace(c::AbstractChar)::Bool
```

文字が空白文字かどうかを判定します。ASCII文字の '\t'、'\n'、'\v'、'\f'、'\r'、' '、Latin-1文字 U+0085、およびUnicodeカテゴリ Zs の文字が対象です。

# Examples

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
