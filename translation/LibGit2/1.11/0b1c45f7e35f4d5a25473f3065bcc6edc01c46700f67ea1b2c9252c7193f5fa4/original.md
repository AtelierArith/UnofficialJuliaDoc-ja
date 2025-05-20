```
checkout_head(repo::GitRepo; options::CheckoutOptions = CheckoutOptions())
```

Update the index and working tree of `repo` to match the commit pointed to by HEAD. `options` controls how the checkout will be performed. See [`CheckoutOptions`](@ref) for more information.

!!! warning
    *Do not* use this function to switch branches! Doing so will cause checkout conflicts.

