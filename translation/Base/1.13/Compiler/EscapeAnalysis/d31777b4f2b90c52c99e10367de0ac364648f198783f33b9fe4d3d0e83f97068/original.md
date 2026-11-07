```julia
x::EscapeInfo ⋤ₑ y::EscapeInfo -> Bool
```

This order could be used as a slightly more efficient version of the strict order `⊏ₑ`, where we can safely assume `x ⊑ₑ y` holds.
