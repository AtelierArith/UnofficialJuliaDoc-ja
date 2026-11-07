```julia
Iterators.map(f, iterators...)
```

Create a lazy mapping.  This is another syntax for writing `(f(args...) for args in zip(iterators...))`.

!!! compat "Julia 1.6"
    This function requires at least Julia 1.6.


# Examples

```jldoctest
julia> collect(Iterators.map(x -> x^2, 1:3))
3-element Vector{Int64}:
 1
 4
 9
```
