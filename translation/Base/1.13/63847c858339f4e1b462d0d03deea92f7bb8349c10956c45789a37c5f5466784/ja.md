```julia
findfirst(pattern::AbstractString, string::AbstractString)
findfirst(pattern::AbstractPattern, string::String)
```

`string` 内で `pattern` が最初に現れる位置を検索します。[`findnext(pattern, string, firstindex(s))`](@ref) と同等です。

# Examples

```jldoctest
julia> findfirst("z", "Hello to the world") # returns nothing, but not printed in the REPL

julia> findfirst("Julia", "JuliaLang")
1:5
```
