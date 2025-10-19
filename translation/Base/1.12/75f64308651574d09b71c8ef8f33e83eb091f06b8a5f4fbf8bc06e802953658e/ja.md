```julia
endswith(s::AbstractString, suffix::Union{AbstractString,Base.Chars})
```

`s`が`suffix`で終わる場合は`true`を返します。`suffix`は文字列、文字、または文字のタプル/ベクター/セットである可能性があります。`suffix`が文字のタプル/ベクター/セットである場合、`s`の最後の文字がそのセットに属するかどうかをテストします。

関連情報としては[`startswith`](@ref)、[`contains`](@ref)があります。

# 例

```jldoctest
julia> endswith("Sunday", "day")
true
```
