```julia
normalize!(a::AbstractArray, p::Real=2)
```

Normalize the array `a` in-place so that its `p`-norm equals unity, i.e. `norm(a, p) == 1`. See also [`normalize`](@ref) and [`norm`](@ref).
