```julia
==(a::AbstractString, b::AbstractString) -> Bool
```

2つの文字列が文字ごとに等しいかどうかをテストします（技術的には、Unicodeコードポイントごとに）。いずれかの文字列が[`AnnotatedString`](@ref)である場合、文字列のプロパティも一致する必要があります。

# 例

```jldoctest
julia> "abc" == "abc"
true

julia> "abc" == "αβγ"
false
```
