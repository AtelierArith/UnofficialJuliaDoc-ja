```
checkout_index(repo::GitRepo, idx::Union{GitIndex, Nothing} = nothing; options::CheckoutOptions = CheckoutOptions())
```

Update the working tree of `repo` to match the index `idx`. If `idx` is `nothing`, the index of `repo` will be used. `options` controls how the checkout will be performed. See [`CheckoutOptions`](@ref) for more information.
