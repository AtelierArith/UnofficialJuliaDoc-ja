```julia
istextmime(m::MIME)
```

MIMEタイプがテキストデータかどうかを判定します。MIMEタイプは、テキストデータ（Unicodeの場合もあります）として知られている一部のタイプを除き、バイナリデータであるとみなされます。

# Examples

```jldoctest
julia> istextmime(MIME("text/plain"))
true

julia> istextmime(MIME("image/png"))
false
```
