```julia
vcat(A...)
```

Concatenate arrays or numbers vertically. Equivalent to [`cat`](@ref)`(A...; dims=1)`, and to the syntax `[a; b; c]`.

To concatenate a large vector of arrays, `reduce(vcat, A)` calls an efficient method when `A isa AbstractVector{<:AbstractVecOrMat}`, rather than working pairwise.

See also [`hcat`](@ref), [`Iterators.flatten`](@ref), [`stack`](@ref).

# Examples

```jldoctest
julia> v = vcat([1,2], [3,4])
4-element Vector{Int64}:
 1
 2
 3
 4

julia> v == vcat(1, 2, [3,4])  # accepts numbers
true

julia> v == [1; 2; [3,4]]  # syntax for the same operation
true

julia> summary(ComplexF64[1; 2; [3,4]])  # syntax for supplying the element type
"4-element Vector{ComplexF64}"

julia> vcat(range(1, 2, length=3))  # collects lazy ranges
3-element Vector{Float64}:
 1.0
 1.5
 2.0

julia> two = ([10, 20, 30]', Float64[4 5 6; 7 8 9])  # row vector and a matrix
(adjoint([10, 20, 30]), [4.0 5.0 6.0; 7.0 8.0 9.0])

julia> vcat(two...)
3×3 Matrix{Float64}:
 10.0  20.0  30.0
  4.0   5.0   6.0
  7.0   8.0   9.0

julia> vs = [[1, 2], [3, 4], [5, 6]];

julia> reduce(vcat, vs)  # more efficient than vcat(vs...)
6-element Vector{Int64}:
 1
 2
 3
 4
 5
 6

julia> ans == collect(Iterators.flatten(vs))
true
```
