```julia
union(s, itrs...)
∪(s, itrs...)
```

Construct an object containing all distinct elements from all of the arguments.

The first argument controls what kind of container is returned. If this is an array, it maintains the order in which elements first appear.

Unicode `∪` can be typed by writing `\cup` then pressing tab in the Julia REPL, and in many editors. This is an infix operator, allowing `s ∪ itr`.

See also [`unique`](@ref), [`intersect`](@ref), [`isdisjoint`](@ref), [`vcat`](@ref), [`Iterators.flatten`](@ref).

# Examples

```jldoctest
julia> union([1, 2], [3])
3-element Vector{Int64}:
 1
 2
 3

julia> union([4 2 3 4 4], 1:3, 3.0)
4-element Vector{Float64}:
 4.0
 2.0
 3.0
 1.0

julia> (0, 0.0) ∪ (-0.0, NaN)
3-element Vector{Real}:
   0
  -0.0
 NaN

julia> union(Set([1, 2]), 2:3)
Set{Int64} with 3 elements:
  2
  3
  1
```
