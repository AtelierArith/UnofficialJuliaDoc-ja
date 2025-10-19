```julia
isless(a::AbstractString, b::AbstractString) -> Bool
```

Test whether string `a` comes before string `b` in alphabetical order (technically, in lexicographical order by Unicode code points).

# Examples

```jldoctest
julia> isless("a", "b")
true

julia> isless("β", "α")
false

julia> isless("a", "a")
false
```
