```julia
firstindex(collection) -> Integer
firstindex(collection, d) -> Integer
```

Return the first index of `collection`. If `d` is given, return the first index of `collection` along dimension `d`.

The syntaxes `A[begin]` and `A[1, begin]` lower to `A[firstindex(A)]` and `A[1, firstindex(A, 2)]`, respectively.

See also: [`first`](@ref), [`axes`](@ref), [`lastindex`](@ref), [`nextind`](@ref).

# Examples

```jldoctest
julia> firstindex([1,2,4])
1

julia> firstindex(rand(3,4,5), 2)
1
```
