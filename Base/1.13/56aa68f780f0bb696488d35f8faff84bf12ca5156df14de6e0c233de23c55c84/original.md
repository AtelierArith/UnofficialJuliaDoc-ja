```julia
Base.rest(collection[, itr_state])
```

Generic function for taking the tail of `collection`, starting from a specific iteration state `itr_state`. Return a `Tuple`, if `collection` itself is a `Tuple`, a subtype of `AbstractVector`, if `collection` is an `AbstractArray`, a subtype of `AbstractString` if `collection` is an `AbstractString`, and an arbitrary iterator, falling back to `Iterators.rest(collection[, itr_state])`, otherwise.

Can be overloaded for user-defined collection types to customize the behavior of [slurping in assignments](@ref destructuring-assignment) in final position, like `a, b... = collection`.

!!! compat "Julia 1.6"
    `Base.rest` requires at least Julia 1.6.


See also: [`first`](@ref first), [`Iterators.rest`](@ref), [`Base.split_rest`](@ref).

# Examples

```jldoctest
julia> a = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> first, state = iterate(a)
(1, 2)

julia> first, Base.rest(a, state)
(1, [3, 2, 4])
```
