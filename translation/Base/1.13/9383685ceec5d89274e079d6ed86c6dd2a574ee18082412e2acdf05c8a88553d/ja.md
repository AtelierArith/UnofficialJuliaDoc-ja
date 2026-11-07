```julia
findlast(pattern::AbstractString, string::AbstractString)
```

`pattern` が `string` 内に最後に現れる位置を検索します。[`findprev(pattern, string, lastindex(string))`](@ref) と同等です。

# Examples

```jldoctest
julia> findlast("o", "Hello to the world")
15:15

julia> findfirst("Julia", "JuliaLang")
1:5
```
