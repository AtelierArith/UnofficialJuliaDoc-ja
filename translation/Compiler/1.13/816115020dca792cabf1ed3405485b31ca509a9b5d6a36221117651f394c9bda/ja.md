```julia
struct PartialsLattice{𝕃<:AbstractLattice} <: AbstractLattice
```

基底格子 `𝕃` を拡張し、`PartialStruct` と `PartialOpaque` を隣接させた格子。
