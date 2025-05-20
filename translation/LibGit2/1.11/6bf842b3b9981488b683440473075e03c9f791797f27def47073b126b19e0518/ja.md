```
diff_tree(repo::GitRepo, oldtree::GitTree, newtree::GitTree)
```

`oldtree`（`DiffDelta`の「古い」側に使用される）と`newtree`（`DiffDelta`の「新しい」側に使用される）との間の[`GitDiff`](@ref)を生成します。これは[`git_diff_tree_to_tree`](https://libgit2.org/libgit2/#HEAD/group/diff/git_diff_tree_to_tree)に相当します。これを使用して、2つのコミット間の差分を生成できます。たとえば、2か月前に行われたコミットと現在の最新のコミットを比較したり、別のブランチのコミットと`master`の現在の最新のコミットを比較したりすることができます。
