```julia
match(r::Regex, s::AbstractString[, idx::Integer[, addopts]])
```

Search for the first match of the regular expression `r` in `s` and return a [`RegexMatch`](@ref) object containing the match, or nothing if the match failed. The optional `idx` argument specifies an index at which to start the search. The matching substring can be retrieved by accessing `m.match`, the captured sequences can be retrieved by accessing `m.captures`. The resulting [`RegexMatch`](@ref) object can be used to construct other collections: e.g. `Tuple(m)`, `NamedTuple(m)`.

!!! compat "Julia 1.11"
    Constructing NamedTuples and Dicts requires Julia 1.11


# Examples

```jldoctest
julia> rx = r"a(.)a"
r"a(.)a"

julia> m = match(rx, "cabac")
RegexMatch("aba", 1="b")

julia> m.captures
1-element Vector{Union{Nothing, SubString{String}}}:
 "b"

julia> m.match
"aba"

julia> match(rx, "cabac", 3) === nothing
true
```
