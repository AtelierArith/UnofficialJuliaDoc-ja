```julia
==(a::AbstractString, b::AbstractString)::Bool
```

2つの文字列が文字単位（厳密には Unicode コードポイント単位）で等しいかどうかを判定します。どちらかの文字列が [`AnnotatedString`](@ref) の場合は、文字列のプロパティも一致している必要があります。

# Examples

```jldoctest
julia> "abc" == "abc"
true

julia> "abc" == "αβγ"
false
```
