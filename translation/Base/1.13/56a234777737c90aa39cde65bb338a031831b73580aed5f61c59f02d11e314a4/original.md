```julia
first(s::AbstractString, n::Integer)
```

Get a string consisting of the first `n` characters of `s`.

# Examples

```jldoctest
julia> first("∀ϵ≠0: ϵ²>0", 0)
""

julia> first("∀ϵ≠0: ϵ²>0", 1)
"∀"

julia> first("∀ϵ≠0: ϵ²>0", 3)
"∀ϵ≠"
```
