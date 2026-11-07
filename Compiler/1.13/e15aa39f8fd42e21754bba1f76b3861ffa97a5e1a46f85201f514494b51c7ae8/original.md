```julia
tmerge(𝕃::AbstractLattice, a, b)
```

Compute a lattice join of elements `a` and `b` over the lattice `𝕃`. Note that the computed element need not be the least upper bound of `a` and `b`, but rather, we impose additional limitations on the complexity of the joined element, ideally without losing too much precision in common cases and remaining mostly associative and commutative.
