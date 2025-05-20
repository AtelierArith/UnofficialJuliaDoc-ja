```
size(A::AbstractArray, [dim])
```

Return a tuple containing the dimensions of `A`. Optionally you can specify a dimension to just get the length of that dimension.

Note that `size` may not be defined for arrays with non-standard indices, in which case [`axes`](@ref) may be useful. See the manual chapter on [arrays with custom indices](@ref man-custom-indices).

See also: [`length`](@ref), [`ndims`](@ref), [`eachindex`](@ref), [`sizeof`](@ref).

# Examples

```jldoctest
julia> A = fill(1, (2,3,4));

julia> size(A)
(2, 3, 4)

julia> size(A, 2)
3
```
