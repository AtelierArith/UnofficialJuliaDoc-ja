```julia
union!(s::IntDisjointSet{T}, x::T, y::T)
```

Merge the subset containing `x` and that containing `y` into one and return the root of the new set.
