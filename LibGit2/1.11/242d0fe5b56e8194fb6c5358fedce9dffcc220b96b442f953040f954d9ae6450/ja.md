```julia
diff_tree(repo::GitRepo, tree::GitTree, pathspecs::AbstractString=""; cached::Bool=false)
```

`tree`（[`DiffDelta`](@ref)の「旧」側として使用）と、`repo`（「新」側として使用）の間に、[`GitDiff`](@ref)を生成します。`repo`が`cached`の場合は、[`git_diff_tree_to_index`](https://libgit2.org/libgit2/#HEAD/group/diff/git_diff_tree_to_index)を呼び出します。通常、`cached`版は、あるコミットから次のコミットまでのステージ済み変更の差分を確認するために使用します。`cached`が`false`の場合は、[`git_diff_tree_to_workdir_with_index`](https://libgit2.org/libgit2/#HEAD/group/diff/git_diff_tree_to_workdir_with_index)を呼び出します。これは、現在の作業ディレクトリと[`GitIndex`](@ref)を比較するため、たとえばコミット前にステージ済みファイルの変更を確認するのに使用できます。
