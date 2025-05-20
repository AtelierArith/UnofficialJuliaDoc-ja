```
eachregion(s::AnnotatedString{S})
eachregion(s::SubString{AnnotatedString{S}})
```

`s`の連続した部分文字列を特定し、定数の注釈を持つ部分文字列と適用可能な注釈を`Tuple{SubString{S}, Vector{@NamedTuple{label::Symbol, value::Any}}}`として提供するイテレータを返します。

# 例

```jldoctest
julia> collect(StyledStrings.eachregion(AnnotatedString(
           "hey there", [(1:3, :face, :bold), (5:9, :face, :italic)])))
3-element Vector{Tuple{SubString{String}, Vector{@NamedTuple{label::Symbol, value}}}}:
 ("hey", [@NamedTuple{label::Symbol, value}((:face, :bold))])
 (" ", [])
 ("there", [@NamedTuple{label::Symbol, value}((:face, :italic))])
```
