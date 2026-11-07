```julia
struct InterConditionalsLattice{𝕃<:AbstractLattice} <: AbstractLattice
```

A lattice extending a base lattice `𝕃` and adjoining `InterConditional`.
