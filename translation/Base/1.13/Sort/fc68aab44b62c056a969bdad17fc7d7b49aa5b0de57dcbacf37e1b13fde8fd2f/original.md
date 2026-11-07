```julia
SubArrayOptimization(next) isa Base.Sort.Algorithm
```

Unwrap certain known SubArrays because views have a performance overhead 😢

Specifically, unwraps some instances of the type

```julia
SubArray{T, 1, <:AbstractArray{T}, <:Tuple{AbstractUnitRange, Vararg{Number}}, true} where T
```
