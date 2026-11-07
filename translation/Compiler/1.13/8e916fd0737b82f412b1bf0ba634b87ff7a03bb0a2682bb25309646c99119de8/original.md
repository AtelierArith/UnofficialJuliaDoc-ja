```julia
⋤(𝕃::AbstractLattice, a, b)::Bool
```

This order could be used as a slightly more efficient version of the strict order `⊏`, where we can safely assume `a ⊑ b` holds.
