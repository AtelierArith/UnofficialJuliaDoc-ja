```
diff_tree(repo::GitRepo, tree::GitTree, pathspecs::AbstractString=""; cached::Bool=false)
```

Generate a [`GitDiff`](@ref) between `tree` (which will be used for the "old" side of the [`DiffDelta`](@ref)) and `repo` (which will be used for the "new" side). If `repo` is `cached`, calls [`git_diff_tree_to_index`](https://libgit2.org/libgit2/#HEAD/group/diff/git_diff_tree_to_index). The `cached` version is generally used to examine the diff for staged changes from one commit to the next. If `cached` is `false`, calls [`git_diff_tree_to_workdir_with_index`](https://libgit2.org/libgit2/#HEAD/group/diff/git_diff_tree_to_workdir_with_index). This compares the current working directory against the [`GitIndex`](@ref) and can, for example, be used to examine the changes in staged files before a commit.
