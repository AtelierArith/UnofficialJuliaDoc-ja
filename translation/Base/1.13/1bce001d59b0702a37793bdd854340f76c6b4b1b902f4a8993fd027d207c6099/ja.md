```julia
isless(a::AbstractString, b::AbstractString)::Bool
```

文字列 `a` が、文字列 `b` よりアルファベット順（厳密には、Unicodeコードポイントによる辞書順）で前に来るかどうかを判定します。

# Examples

```jldoctest
julia> isless("a", "b")
true

julia> isless("β", "α")
false

julia> isless("a", "a")
false
```
