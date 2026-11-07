```julia
quantile(f, v)
```

Apply the function `f` to each element of collection `v` and then compute the quantile(s) at a specified probability or vector or tuple of probabilities `p` on the interval [0,1].

```jldoctest
julia> using Statistics

julia> quantile(√, [1, 3, 2], 0.3)
1.248528137423857

julia> quantile([√1, √3, √2], 0.3)
1.248528137423857

julia> quantile(√, [1, 3, 2], (0.3, 0.4, 0.5))
(1.248528137423857, 1.3313708498984762, 1.4142135623730951)

julia> quantile(.√[1, 3, 2], (0.3, 0.4, 0.5))
(1.248528137423857, 1.3313708498984762, 1.4142135623730951)
```
