```
end
```

`end` marks the conclusion of a block of expressions, for example [`module`](@ref), [`struct`](@ref), [`mutable struct`](@ref), [`begin`](@ref), [`let`](@ref), [`for`](@ref) etc.

`end` may also be used when indexing to represent the last index of a collection or the last index of a dimension of an array.

# Examples

```jldoctest
julia> A = [1 2; 3 4]
2×2 Array{Int64, 2}:
 1  2
 3  4

julia> A[end, :]
2-element Array{Int64, 1}:
 3
 4
```
