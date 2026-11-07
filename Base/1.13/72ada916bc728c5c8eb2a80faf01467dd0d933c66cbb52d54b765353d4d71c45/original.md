```julia
argmax(itr)
```

Return the index or key of the maximal element in a collection. If there are multiple maximal elements, then the first one will be returned.

The collection must not be empty.

Indices are of the same type as those returned by [`keys(itr)`](@ref) and [`pairs(itr)`](@ref).

Values are compared with `isless`.

See also: [`argmin`](@ref), [`findmax`](@ref).

# Examples

```jldoctest
julia> argmax([8, 0.1, -9, pi])
1

julia> argmax([1, 7, 7, 6])
2

julia> argmax([1, 7, 7, NaN])
4
```
