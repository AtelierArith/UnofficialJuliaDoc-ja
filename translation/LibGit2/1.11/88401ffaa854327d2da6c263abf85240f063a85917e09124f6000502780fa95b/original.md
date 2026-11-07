```julia
write_tree_to!(repo::GitRepo, idx::GitIndex)::GitHash
```

Write the index `idx` as a [`GitTree`](@ref) to the given repository `repo`. This is similar to [`write_tree!`](@ref) but allows writing the index to a different repository than the one it may be associated with.

Trees will be recursively created for each subtree in `idx`. The returned [`GitHash`](@ref) can be used to create a [`GitCommit`](@ref).

This is equivalent to [`git_index_write_tree_to`](https://libgit2.org/libgit2/#HEAD/group/index/git_index_write_tree_to).

# Examples

```julia
idx = LibGit2.GitIndex(source_repo)
tree_oid = LibGit2.write_tree_to!(target_repo, idx)
```
