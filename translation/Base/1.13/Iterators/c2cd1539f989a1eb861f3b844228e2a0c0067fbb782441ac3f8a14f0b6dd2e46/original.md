```julia
findeach(f, it)
findeach(it)
```

An iterator that generates every key from the key/value pairs of `pairs(it)`, where `f(value)` returns `true`.

If `f` is not specified, default to `identity`.

`Iterators.findeach` is the lazy equivalent of `findall`.

!!! compat "Julia 1.13"
    `findeach` requires at least Julia 1.13.


# Examples

```jldoctest
julia> collect(Iterators.findeach(isodd, Dict(2 => 3, 3 => 2)))
1-element Vector{Int64}:
 2

julia> only(Iterators.findeach(==(1), [3,6,2,1]))
4
```
