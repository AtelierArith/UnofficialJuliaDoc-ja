```julia
LibGit2.addblob!(repo::GitRepo, path::AbstractString)
```

`path` のファイルを読み込み、`repo` のオブジェクトデータベースにルーズオブジェクトとして追加します。生成された blob の [`GitHash`](@ref) を返します。

# Examples

```julia
hash_str = string(commit_oid)
blob_file = joinpath(repo_path, ".git", "objects", hash_str[1:2], hash_str[3:end])
id = LibGit2.addblob!(repo, blob_file)
```
