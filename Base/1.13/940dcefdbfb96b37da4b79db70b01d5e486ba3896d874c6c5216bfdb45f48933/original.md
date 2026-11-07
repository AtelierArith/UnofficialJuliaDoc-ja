```julia
map(f, A::AbstractArray...) -> N-array
```

When acting on multi-dimensional arrays of the same [`ndims`](@ref), they must all have the same [`axes`](@ref), and the answer will too.

See also [`broadcast`](@ref), which allows mismatched sizes.

# Examples

```julia
julia> map(//, [1 2; 3 4], [4 3; 2 1])
2×2 Matrix{Rational{Int64}}:
 1//4  2//3
 3//2  4//1

julia> map(+, [1 2; 3 4], zeros(2,1))
ERROR: DimensionMismatch

julia> map(+, [1 2; 3 4], [1,10,100,1000], zeros(3,1))  # iterates until 3rd is exhausted
3-element Vector{Float64}:
   2.0
  13.0
 102.0
```
