```julia
mean(f, itr)
```

Apply the function `f` to each element of collection `itr` and take the mean.

```jldoctest
julia> using Statistics

julia> mean(√, [1, 2, 3])
1.3820881233139908

julia> mean([√1, √2, √3])
1.3820881233139908
```
