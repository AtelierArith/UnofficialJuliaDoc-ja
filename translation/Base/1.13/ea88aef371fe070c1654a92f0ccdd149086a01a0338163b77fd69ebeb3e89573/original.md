```julia
complex(A::AbstractArray)
```

Return an array containing the complex analog of each entry in array `A`.

Equivalent to `complex.(A)`, except that the return value may share memory with all or part of `A` in accordance with the behavior of `convert(T, A)` given output type `T`.

# Examples

```jldoctest
julia> complex([1, 2, 3])
3-element Vector{Complex{Int64}}:
 1 + 0im
 2 + 0im
 3 + 0im
```
