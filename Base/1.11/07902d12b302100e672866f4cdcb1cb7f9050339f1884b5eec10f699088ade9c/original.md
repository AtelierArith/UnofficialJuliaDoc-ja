```
findmin(itr) -> (x, index)
```

Return the minimal element of the collection `itr` and its index or key. If there are multiple minimal elements, then the first one will be returned. `NaN` is treated as less than all other values except `missing`.

Indices are of the same type as those returned by [`keys(itr)`](@ref) and [`pairs(itr)`](@ref).

See also: [`findmax`](@ref), [`argmin`](@ref), [`minimum`](@ref).

# Examples

```jldoctest
julia> findmin([8, 0.1, -9, pi])
(-9.0, 3)

julia> findmin([1, 7, 7, 6])
(1, 1)

julia> findmin([1, 7, 7, NaN])
(NaN, 4)
```
