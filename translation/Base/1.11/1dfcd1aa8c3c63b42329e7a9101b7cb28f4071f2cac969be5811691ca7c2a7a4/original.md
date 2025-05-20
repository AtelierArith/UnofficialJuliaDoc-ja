```
popfirst!(collection) -> item
```

Remove the first `item` from `collection`.

This function is called `shift` in many other programming languages.

See also: [`pop!`](@ref), [`popat!`](@ref), [`delete!`](@ref).

# Examples

```jldoctest
julia> A = [1, 2, 3, 4, 5, 6]
6-element Vector{Int64}:
 1
 2
 3
 4
 5
 6

julia> popfirst!(A)
1

julia> A
5-element Vector{Int64}:
 2
 3
 4
 5
 6
```
