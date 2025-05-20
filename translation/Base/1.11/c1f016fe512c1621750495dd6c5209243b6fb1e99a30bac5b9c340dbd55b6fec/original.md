```
union!(s::Union{AbstractSet,AbstractVector}, itrs...)
```

Construct the [`union`](@ref) of passed in sets and overwrite `s` with the result. Maintain order with arrays.

!!! warning
    Behavior can be unexpected when any mutated argument shares memory with any other argument.


# Examples

```jldoctest
julia> a = Set([3, 4, 5]);

julia> union!(a, 1:2:7);

julia> a
Set{Int64} with 5 elements:
  5
  4
  7
  3
  1
```
