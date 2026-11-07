```julia
struct PartialsLattice{𝕃<:AbstractLattice} <: AbstractLattice
```

A lattice extending a base lattice `𝕃` and adjoining `PartialStruct` and `PartialOpaque`.
