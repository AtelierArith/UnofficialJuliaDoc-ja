```julia
occursin(needle::Union{AbstractString,AbstractPattern,AbstractChar}, haystack::AbstractString)
```

最初の引数が2番目の引数の部分文字列であるかどうかを判断します。`needle`が正規表現の場合、`haystack`に一致が含まれているかどうかをチェックします。

# 例

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

他にも[`contains`](@ref)があります。
