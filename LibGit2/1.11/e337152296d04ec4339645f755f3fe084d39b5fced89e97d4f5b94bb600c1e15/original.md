```julia
apply_to_tree(repo::GitRepo, preimage::GitTree, diff::GitDiff, options::ApplyOptions=ApplyOptions())
```

Apply a [`GitDiff`](@ref) to a [`GitTree`](@ref), returning the resulting index. The `preimage` is the tree to which the diff will be applied. The `diff` should be generated from the `preimage` to some other tree.

The returned [`GitIndex`](@ref) contains the result of applying the diff and can be written as a tree using [`write_tree_to!`](@ref).

This is equivalent to [`git_apply_to_tree`](https://libgit2.org/libgit2/#HEAD/group/apply/git_apply_to_tree).

# Examples

```julia
repo = LibGit2.GitRepo(repo_path)
tree1 = LibGit2.GitTree(repo, "HEAD^{tree}")
tree2 = LibGit2.GitTree(repo, "HEAD~1^{tree}")
diff = LibGit2.diff_tree(repo, tree1, tree2)
result_index = LibGit2.apply_to_tree(repo, tree1, diff)
tree_oid = LibGit2.write_tree_to!(repo, result_index)
```
