```julia
tmerge_field(𝕃::AbstractLattice, a, b) -> nothing or lattice element
```

Compute a lattice join of elements `a` and `b` over the lattice `𝕃`, where `a` and `b` are fields of `PartialStruct` or `Const`. This is an opt-in interface to allow external lattice implementation to provide its own field-merge strategy. If it returns `nothing`, `tmerge(::PartialsLattice, ...)` will use the default aggressive type merge implementation that does not use `tmerge` recursively to reach convergence.
