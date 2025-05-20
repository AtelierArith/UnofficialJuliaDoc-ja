```
contains(haystack::AbstractString, needle)
```

`haystack`が`needle`を含む場合は`true`を返します。これは`occursin(needle, haystack)`と同じですが、`startswith(haystack, needle)`および`endswith(haystack, needle)`との一貫性のために提供されています。

他にも[`occursin`](@ref)、[`in`](@ref)、[`issubset`](@ref)を参照してください。

# 例

```jldoctest
julia> contains("JuliaLang is pretty cool!", "Julia")
true

julia> contains("JuliaLang is pretty cool!", 'a')
true

julia> contains("aba", r"a.a")
true

julia> contains("abba", r"a.a")
false
```

!!! compat "Julia 1.5"
    `contains`関数は少なくともJulia 1.5が必要です。

