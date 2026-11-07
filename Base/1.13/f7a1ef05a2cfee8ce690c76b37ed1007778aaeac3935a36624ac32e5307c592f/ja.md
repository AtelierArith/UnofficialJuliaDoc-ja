```julia
startswith(s::AbstractString, prefix::Union{AbstractString,Base.Chars})
```

`s` が `prefix`（文字列、文字、または文字のタプル・ベクター・集合）で始まる場合、`true` を返します。`prefix` が文字のタプル・ベクター・集合の場合は、`s` の最初の文字がその集合に含まれるかどうかを判定します。

関連項目: [`endswith`](@ref)、[`contains`](@ref)。

# Examples

```jldoctest
julia> startswith("JuliaLang", "Julia")
true
```
