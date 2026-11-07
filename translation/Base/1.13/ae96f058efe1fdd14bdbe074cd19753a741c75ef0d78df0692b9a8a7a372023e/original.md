```julia
float(A::AbstractArray)
```

Return an array containing the floating-point analog of each entry in array `A`.

Equivalent to `float.(A)`, except that the return value may share memory with all or part of `A` in accordance with the behavior of `convert(T, A)` given output type `T`.

# Examples

```jldoctest
julia> float(1:1000)
1.0:1.0:1000.0
```
