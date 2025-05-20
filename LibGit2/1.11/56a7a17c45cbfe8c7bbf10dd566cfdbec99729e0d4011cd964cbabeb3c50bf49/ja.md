```
diff_tree(repo::GitRepo, tree::GitTree, pathspecs::AbstractString=""; cached::Bool=false)
```

`tree`（[`DiffDelta`](@ref) の「古い」側に使用される）と `repo`（「新しい」側に使用される）との間の [`GitDiff`](@ref) を生成します。`repo` が `cached` の場合、[`git_diff_tree_to_index`](https://libgit2.org/libgit2/#HEAD/group/diff/git_diff_tree_to_index) を呼び出します。`cached` バージョンは、一般的に、1つのコミットから次のコミットへのステージされた変更の差分を調べるために使用されます。`cached` が `false` の場合、[`git_diff_tree_to_workdir_with_index`](https://libgit2.org/libgit2/#HEAD/group/diff/git_diff_tree_to_workdir_with_index) を呼び出します。これは、現在の作業ディレクトリを [`GitIndex`](@ref) と比較し、例えば、コミット前にステージされたファイルの変更を調べるために使用できます。
