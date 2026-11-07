```julia
findall(c::AbstractChar, s::AbstractString)
```

Return a vector `I` of the indices of `s` where `s[i] == c`. If there are no such elements in `s`, return an empty array.

# Examples

```jldoctest
julia> findall('a', "batman")
2-element Vector{Int64}:
 2
 5
```

!!! compat "Julia 1.7"
    This method requires at least Julia 1.7.

