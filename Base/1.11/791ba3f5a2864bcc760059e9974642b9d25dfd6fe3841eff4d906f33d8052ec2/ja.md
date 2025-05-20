```
findfirst(pattern::AbstractString, string::AbstractString)
findfirst(pattern::AbstractPattern, string::String)
```

`string`内の`pattern`の最初の出現を見つけます。[`findnext(pattern, string, firstindex(s))`](@ref)と同等です。

# 例

```jldoctest
julia> findfirst("z", "Hello to the world") # 何も返さないが、REPLには表示されない

julia> findfirst("Julia", "JuliaLang")
1:5
```
