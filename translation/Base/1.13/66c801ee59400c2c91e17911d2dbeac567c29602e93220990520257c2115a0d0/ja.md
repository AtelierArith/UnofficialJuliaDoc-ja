```julia
occursin(needle::Union{AbstractString,AbstractPattern,AbstractChar}, haystack::AbstractString)
```

第1引数が第2引数の部分文字列かどうかを判定します。`needle`が正規表現の場合は、`haystack`に一致する部分が含まれているかどうかを判定します。

# Examples

```jldoctest
julia> occursin("Julia", "JuliaLang is pretty cool!")
true

julia> occursin('a', "JuliaLang is pretty cool!")
true

julia> occursin(r"a.a", "aba")
true

julia> occursin(r"a.a", "abba")
false
```

[`contains`](@ref)。
