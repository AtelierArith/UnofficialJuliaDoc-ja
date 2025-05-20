```
isempty(collection) -> Bool
```

Determine whether a collection is empty (has no elements).

!!! warning
    `isempty(itr)` may consume the next element of a stateful iterator `itr` unless an appropriate [`Base.isdone(itr)`](@ref) method is defined. Stateful iterators *should* implement `isdone`, but you may want to avoid using `isempty` when writing generic code which should support any iterator type.


# Examples

```jldoctest
julia> isempty([])
true

julia> isempty([1 2 3])
false
```
