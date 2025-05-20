```
findlast(pattern::AbstractString, string::AbstractString)
```

`string`内の`pattern`の最後の出現を見つけます。[`findprev(pattern, string, lastindex(string))`](@ref)と同等です。

# 例

```jldoctest
julia> findlast("o", "Hello to the world")
15:15

julia> findfirst("Julia", "JuliaLang")
1:5
```
