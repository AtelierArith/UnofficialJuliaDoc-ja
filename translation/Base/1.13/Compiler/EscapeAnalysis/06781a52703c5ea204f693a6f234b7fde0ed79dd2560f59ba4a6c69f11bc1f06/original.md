```julia
root_union!(s::IntDisjointSet{T}, x::T, y::T)
```

Form a new set that is the union of the two sets whose root elements are `x` and `y` and return the root of the new set. Assume `x ≠ y` (unsafe).
