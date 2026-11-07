```julia
==(a::AbstractString, b::AbstractString)::Bool
```

2つの文字列が、文字ごと（厳密には Unicode コードポイントごと）に等しいかどうかを判定します。いずれかの文字列が [`AnnotatedString`](@ref) の場合は、文字列のプロパティも一致している必要があります。

# Examples

```jldoctest
julia> "abc" == "abc"
true

julia> "abc" == "αβγ"
false
```
