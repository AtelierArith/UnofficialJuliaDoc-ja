```julia
estate::EscapeState
```

Extended lattice that maps arguments and SSA values to escape information represented as [`EscapeInfo`](@ref). Escape information imposed on SSA IR element `x` can be retrieved by `estate[x]`.
