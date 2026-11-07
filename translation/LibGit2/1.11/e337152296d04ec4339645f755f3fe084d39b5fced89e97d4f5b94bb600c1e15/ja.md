```julia
apply_to_tree(repo::GitRepo, preimage::GitTree, diff::GitDiff, options::ApplyOptions=ApplyOptions())
```

[`GitTree`](@ref) に [`GitDiff`](@ref) を適用し、結果のインデックスを返します。`preimage` は、差分を適用するツリーです。`diff` は、`preimage` から別のツリーへの差分として生成します。

返される [`GitIndex`](@ref) には、差分を適用した結果が含まれます。これを [`write_tree_to!`](@ref) を使ってツリーとして書き出せます。

これは [`git_apply_to_tree`](https://libgit2.org/libgit2/#HEAD/group/apply/git_apply_to_tree) と同等です。

# Examples

```julia
repo = LibGit2.GitRepo(repo_path)
tree1 = LibGit2.GitTree(repo, "HEAD^{tree}")
tree2 = LibGit2.GitTree(repo, "HEAD~1^{tree}")
diff = LibGit2.diff_tree(repo, tree1, tree2)
result_index = LibGit2.apply_to_tree(repo, tree1, diff)
tree_oid = LibGit2.write_tree_to!(repo, result_index)
```
