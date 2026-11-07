```julia
filter(f, a)
```

Return a copy of collection `a`, removing elements for which `f` is `false`. The function `f` is passed one argument.

!!! compat "Julia 1.4"
    Support for `a` as a tuple requires at least Julia 1.4.


See also: [`filter!`](@ref), [`Iterators.filter`](@ref).

# Examples

```jldoctest
julia> a = 1:10
1:10

julia> filter(isodd, a)
5-element Vector{Int64}:
 1
 3
 5
 7
 9
```
