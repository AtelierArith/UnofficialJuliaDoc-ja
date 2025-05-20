```
isless(a::AbstractString, b::AbstractString) -> Bool
```

文字列 `a` が文字列 `b` よりもアルファベット順で前に来るかどうかをテストします（技術的には、Unicode コードポイントによる辞書式順序で）。

# 例

```jldoctest
julia> isless("a", "b")
true

julia> isless("β", "α")
false

julia> isless("a", "a")
false
```
