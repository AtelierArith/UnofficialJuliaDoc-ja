```
istextmime(m::MIME)
```

MIMEタイプがテキストデータであるかどうかを判断します。MIMEタイプは、テキストデータとして知られている一部のタイプを除いて、バイナリデータであると見なされます（おそらくUnicode）。

# 例

```jldoctest
julia> istextmime(MIME("text/plain"))
true

julia> istextmime(MIME("image/png"))
false
```
