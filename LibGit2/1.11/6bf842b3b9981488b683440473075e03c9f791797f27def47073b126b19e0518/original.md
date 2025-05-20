```
diff_tree(repo::GitRepo, oldtree::GitTree, newtree::GitTree)
```

Generate a [`GitDiff`](@ref) between `oldtree` (which will be used for the "old" side of the [`DiffDelta`](@ref)) and `newtree` (which will be used for the "new" side of the `DiffDelta`). Equivalent to [`git_diff_tree_to_tree`](https://libgit2.org/libgit2/#HEAD/group/diff/git_diff_tree_to_tree). This can be used to generate a diff between two commits. For instance, it could be used to compare a commit made 2 months ago with the current latest commit, or to compare a commit on another branch with the current latest commit on `master`.
