```julia
matchregions(spec::FilterSpec, candidate::AbstractString) -> Vector{UnitRange{Int}}
```

Find all matching character ranges in `candidate` for `spec`.

Collects exact-substring and regex matches, then returns them sorted by start index (and longer matches first).
