```julia
diagm(v::AbstractVector)
diagm(m::Integer, n::Integer, v::AbstractVector)
```

Construct a matrix with elements of the vector as diagonal elements. By default, the matrix is square and its size is given by `length(v)`, but a non-square size `m`×`n` can be specified by passing `m,n` as the first arguments. The diagonal will be zero-padded if necessary.

# Examples

```jldoctest
julia> diagm([1,2,3])
3×3 Matrix{Int64}:
 1  0  0
 0  2  0
 0  0  3

julia> diagm(4, 5, [1,2,3])
4×5 Matrix{Int64}:
 1  0  0  0  0
 0  2  0  0  0
 0  0  3  0  0
 0  0  0  0  0
```
