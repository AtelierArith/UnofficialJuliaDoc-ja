```julia
diff_tree(repo::GitRepo, oldtree::GitTree, newtree::GitTree)
```

`oldtree`（[`DiffDelta`](@ref)の「旧」側として使用）と、`newtree`（`DiffDelta`の「新」側として使用）の間に[`GitDiff`](@ref)を生成します。[`git_diff_tree_to_tree`](https://libgit2.org/libgit2/#HEAD/group/diff/git_diff_tree_to_tree)と同等です。これを使って、2つのコミット間の差分を生成できます。たとえば、2か月前のコミットと現在の最新コミットを比較したり、別のブランチ上のコミットと`master`上の現在の最新コミットを比較したりできます。
