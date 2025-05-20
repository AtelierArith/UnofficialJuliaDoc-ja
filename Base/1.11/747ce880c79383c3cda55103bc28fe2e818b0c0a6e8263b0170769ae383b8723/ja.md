```
chomp(s::AbstractString) -> SubString
```

文字列から単一の末尾改行を削除します。

関連項目として[`chop`](@ref)があります。

# 例

```jldoctest
julia> chomp("Hello\n")
"Hello"
```
