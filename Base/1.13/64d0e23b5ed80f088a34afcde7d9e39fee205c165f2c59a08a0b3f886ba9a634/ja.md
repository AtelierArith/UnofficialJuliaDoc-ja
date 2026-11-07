```julia
contains(haystack::AbstractString, needle)
```

`haystack`に`needle`が含まれている場合は、`true`を返します。これは`occursin(needle, haystack)`と同じですが、`startswith(haystack, needle)`および`endswith(haystack, needle)`との一貫性を保つために用意されています。

関連項目：[`occursin`](@ref)、[`in`](@ref)、[`issubset`](@ref)。

# Examples

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
    `contains`関数を使用するには、Julia 1.5以降が必要です。

