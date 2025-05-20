```
Base.split_rest(collection, n::Int[, itr_state]) -> (rest_but_n, last_n)
```

Generic function for splitting the tail of `collection`, starting from a specific iteration state `itr_state`. Returns a tuple of two new collections. The first one contains all elements of the tail but the `n` last ones, which make up the second collection.

The type of the first collection generally follows that of [`Base.rest`](@ref), except that the fallback case is not lazy, but is collected eagerly into a vector.

Can be overloaded for user-defined collection types to customize the behavior of [slurping in assignments](@ref destructuring-assignment) in non-final position, like `a, b..., c = collection`.

!!! compat "Julia 1.9"
    `Base.split_rest` requires at least Julia 1.9.


See also: [`Base.rest`](@ref).

# Examples

```jldoctest
julia> a = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> first, state = iterate(a)
(1, 2)

julia> first, Base.split_rest(a, 1, state)
(1, ([3, 2], [4]))
```
