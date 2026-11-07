```julia
findlast(pattern::AbstractString, string::AbstractString)
```

`string` 内で `pattern` が最後に出現する位置を検索します。[`findprev(pattern, string, lastindex(string))`](@ref) と同等です。

# Examples

```jldoctest
julia> findlast("o", "Hello to the world")
15:15

julia> findfirst("Julia", "JuliaLang")
1:5
```
