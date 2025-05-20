```
reverse(v [, start=firstindex(v) [, stop=lastindex(v) ]] )
```

Return a copy of `v` reversed from start to stop.  See also [`Iterators.reverse`](@ref) for reverse-order iteration without making a copy, and in-place [`reverse!`](@ref).

# Examples

```jldoctest
julia> A = Vector(1:5)
5-element Vector{Int64}:
 1
 2
 3
 4
 5

julia> reverse(A)
5-element Vector{Int64}:
 5
 4
 3
 2
 1

julia> reverse(A, 1, 4)
5-element Vector{Int64}:
 4
 3
 2
 1
 5

julia> reverse(A, 3, 5)
5-element Vector{Int64}:
 1
 2
 5
 4
 3
```
