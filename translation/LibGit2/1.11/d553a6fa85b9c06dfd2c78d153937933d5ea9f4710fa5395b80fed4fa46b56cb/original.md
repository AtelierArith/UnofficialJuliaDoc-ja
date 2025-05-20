```
checkout_tree(repo::GitRepo, obj::GitObject; options::CheckoutOptions = CheckoutOptions())
```

Update the working tree and index of `repo` to match the tree pointed to by `obj`. `obj` can be a commit, a tag, or a tree. `options` controls how the checkout will be performed. See [`CheckoutOptions`](@ref) for more information.
