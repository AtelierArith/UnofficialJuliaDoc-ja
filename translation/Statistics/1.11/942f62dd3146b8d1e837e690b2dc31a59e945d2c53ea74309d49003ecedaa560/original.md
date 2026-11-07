```julia
median(f, v)
```

Apply the function `f` to each element of collection `v` and then compute the median.

```jldoctest
julia> using Statistics

julia> median(√, [1, 3, 2])
1.4142135623730951

julia> median([√1, √3, √2])
1.4142135623730951
```
