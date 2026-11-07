```julia
const VarTable = Vector{VarState}
```

The extended lattice that maps local variables to inferred type represented as `AbstractLattice`. Each index corresponds to the `id` of `SlotNumber` which identifies each local variable. Note that `InferenceState` will maintain multiple `VarTable`s at each SSA statement to enable flow-sensitive analysis.
