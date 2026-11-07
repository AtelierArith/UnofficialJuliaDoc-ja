```julia
find_root!(s::IntDisjointSet{T}, x::T)
```

Find the root element of the subset that contains an member `x`. Path compression happens here.
