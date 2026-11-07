```julia
middle(a::AbstractArray)
```

Compute the middle of an array `a`, which consists of finding its extrema and then computing their mean.

```jldoctest
julia> using Statistics

julia> middle(1:10)
5.5

julia> a = [1,2,3.6,10.9]
4-element Vector{Float64}:
  1.0
  2.0
  3.6
 10.9

julia> middle(a)
5.95
```
