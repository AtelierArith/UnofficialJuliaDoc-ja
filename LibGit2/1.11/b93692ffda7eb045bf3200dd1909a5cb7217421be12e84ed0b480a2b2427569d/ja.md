```julia
GitRemote(repo::GitRepo, rmt_name::AbstractString, rmt_url::AbstractString) -> GitRemote
```

リモートgitリポジトリをその名前とURLを使用して検索します。デフォルトのフェッチrefspecを使用します。

# 例

```julia
repo = LibGit2.init(repo_path)
remote = LibGit2.GitRemote(repo, "upstream", repo_url)
```
