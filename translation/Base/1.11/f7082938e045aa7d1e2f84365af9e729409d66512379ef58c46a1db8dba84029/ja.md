```
SubString(s::AbstractString, i::Integer, j::Integer=lastindex(s))
SubString(s::AbstractString, r::UnitRange{<:Integer})
```

[`getindex`](@ref)と同様ですが、コピーを作成するのではなく、範囲`i:j`または`r`内の親文字列`s`へのビューを返します。

[`@views`](@ref)マクロは、コードブロック内の任意の文字列スライス`s[i:j]`を部分文字列`SubString(s, i, j)`に変換します。

# 例

```jldoctest
julia> SubString("abc", 1, 2)
"ab"

julia> SubString("abc", 1:2)
"ab"

julia> SubString("abc", 2)
"bc"
```
