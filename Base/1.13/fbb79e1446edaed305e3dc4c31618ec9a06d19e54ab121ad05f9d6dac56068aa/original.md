```julia
skipmissing(itr)
```

Return an iterator over the elements in `itr` skipping [`missing`](@ref) values. The returned object can be indexed using indices of `itr` if the latter is indexable. Indices corresponding to missing values are not valid: they are skipped by [`keys`](@ref) and [`eachindex`](@ref), and a `MissingException` is thrown when trying to use them.

Use [`collect`](@ref) to obtain an `Array` containing the non-`missing` values in `itr`. Note that even if `itr` is a multidimensional array, the result will always be a `Vector` since it is not possible to remove missings while preserving dimensions of the input.

See also [`coalesce`](@ref), [`ismissing`](@ref), [`something`](@ref).

# Examples

```jldoctest
julia> x = skipmissing([1, missing, 2])
skipmissing(Union{Missing, Int64}[1, missing, 2])

julia> sum(x)
3

julia> x[1]
1

julia> x[2]
ERROR: MissingException: the value at index (2,) is missing
[...]

julia> argmax(x)
3

julia> collect(keys(x))
2-element Vector{Int64}:
 1
 3

julia> collect(skipmissing([1, missing, 2]))
2-element Vector{Int64}:
 1
 2

julia> collect(skipmissing([1 missing; 2 missing]))
2-element Vector{Int64}:
 1
 2
```
