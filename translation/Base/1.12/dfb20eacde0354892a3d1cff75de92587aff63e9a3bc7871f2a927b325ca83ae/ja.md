```julia
startswith(s::AbstractString, prefix::Union{AbstractString,Base.Chars})
```

`s`が`prefix`で始まる場合は`true`を返します。`prefix`は文字列、文字、または文字のタプル/ベクター/セットである可能性があります。`prefix`が文字のタプル/ベクター/セットである場合、`s`の最初の文字がそのセットに属するかどうかをテストします。

[`endswith`](@ref)や[`contains`](@ref)も参照してください。

# 例

```jldoctest
julia> startswith("JuliaLang", "Julia")
true
```
