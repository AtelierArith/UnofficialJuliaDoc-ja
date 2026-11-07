```julia
push!(s::IntDisjointSet{T})
```

Make a new subset with an automatically chosen new element `x`. Returns the new element. Throw an `ArgumentError` if the capacity of the set would be exceeded.
