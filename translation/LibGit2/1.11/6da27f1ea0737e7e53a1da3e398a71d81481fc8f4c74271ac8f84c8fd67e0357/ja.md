```
LibGit2.addblob!(repo::GitRepo, path::AbstractString)
```

`path`で指定されたファイルを読み込み、`repo`のオブジェクトデータベースにロースブロブとして追加します。結果のブロブの[`GitHash`](@ref)を返します。

# 例

```julia
hash_str = string(commit_oid)
blob_file = joinpath(repo_path, ".git", "objects", hash_str[1:2], hash_str[3:end])
id = LibGit2.addblob!(repo, blob_file)
```
