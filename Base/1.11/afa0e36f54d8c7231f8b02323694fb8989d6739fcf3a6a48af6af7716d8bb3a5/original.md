```
intersect(s, itrs...)
∩(s, itrs...)
```

Construct the set containing those elements which appear in all of the arguments.

The first argument controls what kind of container is returned. If this is an array, it maintains the order in which elements first appear.

Unicode `∩` can be typed by writing `\cap` then pressing tab in the Julia REPL, and in many editors. This is an infix operator, allowing `s ∩ itr`.

See also [`setdiff`](@ref), [`isdisjoint`](@ref), [`issubset`](@ref Base.issubset), [`issetequal`](@ref).

!!! compat "Julia 1.8"
    As of Julia 1.8 intersect returns a result with the eltype of the type-promoted eltypes of the two inputs


# Examples

```jldoctest
julia> intersect([1, 2, 3], [3, 4, 5])
1-element Vector{Int64}:
 3

julia> intersect([1, 4, 4, 5, 6], [6, 4, 6, 7, 8])
2-element Vector{Int64}:
 4
 6

julia> intersect(1:16, 7:99)
7:16

julia> (0, 0.0) ∩ (-0.0, 0)
1-element Vector{Real}:
 0

julia> intersect(Set([1, 2]), BitSet([2, 3]), 1.0:10.0)
Set{Float64} with 1 element:
  2.0
```
