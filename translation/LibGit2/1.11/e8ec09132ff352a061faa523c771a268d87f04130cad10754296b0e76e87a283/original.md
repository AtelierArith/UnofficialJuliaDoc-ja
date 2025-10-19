```julia
merge!(repo::GitRepo, anns::Vector{GitAnnotated}; kwargs...) -> Bool
```

Merge changes from the annotated commits (captured as [`GitAnnotated`](@ref) objects) `anns` into the HEAD of the repository `repo`. The keyword arguments are:

  * `merge_opts::MergeOptions = MergeOptions()`: options for how to perform the merge, including whether fastforwarding is allowed. See [`MergeOptions`](@ref) for more information.
  * `checkout_opts::CheckoutOptions = CheckoutOptions()`: options for how to perform the checkout. See [`CheckoutOptions`](@ref) for more information.

`anns` may refer to remote or local branch heads. Return `true` if the merge is successful, otherwise return `false` (for instance, if no merge is possible because the branches have no common ancestor).

# Examples

```julia
upst_ann = LibGit2.GitAnnotated(repo, "branch/a")

# merge the branch in
LibGit2.merge!(repo, [upst_ann])
```
