```
argmin(itr)
```

Return the index or key of the minimal element in a collection. If there are multiple minimal elements, then the first one will be returned.

The collection must not be empty.

Indices are of the same type as those returned by [`keys(itr)`](@ref) and [`pairs(itr)`](@ref).

`NaN` is treated as less than all other values except `missing`.

See also: [`argmax`](@ref), [`findmin`](@ref).

# Examples

```jldoctest
julia> argmin([8, 0.1, -9, pi])
3

julia> argmin([7, 1, 1, 6])
2

julia> argmin([7, 1, 1, NaN])
4
```
