```julia
endswith(s::AbstractString, suffix::Union{AbstractString,Base.Chars})
```

`s` が `suffix` で終わる場合、`true` を返します。ここで、末尾として指定できるのは文字列、文字、または文字のタプル・ベクトル・集合です。`suffix` が文字のタプル・ベクトル・集合の場合は、`s` の最後の文字がその集合に含まれるかどうかを判定します。

[`startswith`](@ref)、[`contains`](@ref) も参照してください。

# Examples

```jldoctest
julia> endswith("Sunday", "day")
true
```