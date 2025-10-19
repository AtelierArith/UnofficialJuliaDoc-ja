```julia
reinterpret(reshape, T, A::AbstractArray{S}) -> B
```

Change the type-interpretation of `A` while consuming or adding a "channel dimension."

If `sizeof(T) = n*sizeof(S)` for `n>1`, `A`'s first dimension must be of size `n` and `B` lacks `A`'s first dimension. Conversely, if `sizeof(S) = n*sizeof(T)` for `n>1`, `B` gets a new first dimension of size `n`. The dimensionality is unchanged if `sizeof(T) == sizeof(S)`.

!!! compat "Julia 1.6"
    This method requires at least Julia 1.6.


# Examples

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> reinterpret(reshape, Complex{Int}, A)    # the result is a vector
2-element reinterpret(reshape, Complex{Int64}, ::Matrix{Int64}) with eltype Complex{Int64}:
 1 + 3im
 2 + 4im

julia> a = [(1,2,3), (4,5,6)]
2-element Vector{Tuple{Int64, Int64, Int64}}:
 (1, 2, 3)
 (4, 5, 6)

julia> reinterpret(reshape, Int, a)             # the result is a matrix
3×2 reinterpret(reshape, Int64, ::Vector{Tuple{Int64, Int64, Int64}}) with eltype Int64:
 1  4
 2  5
 3  6
```
