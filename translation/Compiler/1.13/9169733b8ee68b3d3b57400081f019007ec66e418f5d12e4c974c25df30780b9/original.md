```julia
is_const_prop_profitable_arg(𝕃::AbstractLattice, t)::Bool
```

Determines whether the given lattice element `t` of `𝕃` has new extended lattice information that should be forwarded along with constant propagation.
