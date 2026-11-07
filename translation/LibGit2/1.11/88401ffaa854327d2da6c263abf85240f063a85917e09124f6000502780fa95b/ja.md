```julia
write_tree_to!(repo::GitRepo, idx::GitIndex)::GitHash
```

インデックス `idx` を、指定したリポジトリ `repo` への [`GitTree`](@ref) として書き込みます。これは [`write_tree!`](@ref) と似ていますが、インデックスが関連付けられているリポジトリとは別のリポジトリに書き込めます。

`idx` 内の各サブツリーについて、ツリーが再帰的に作成されます。返される [`GitHash`](@ref) を使って、[`GitCommit`](@ref) を作成できます。

これは [`git_index_write_tree_to`](https://libgit2.org/libgit2/#HEAD/group/index/git_index_write_tree_to) と同等です。

# Examples

```julia
idx = LibGit2.GitIndex(source_repo)
tree_oid = LibGit2.write_tree_to!(target_repo, idx)
```
