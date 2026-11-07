```julia
GitRemote(repo::GitRepo, rmt_name::AbstractString, rmt_url::AbstractString)::GitRemote
```

名前と URL を使ってリモートの Git リポジトリを検索します。デフォルトのフェッチ refspec を使用します。

# Examples

```julia
repo = LibGit2.init(repo_path)
remote = LibGit2.GitRemote(repo, "upstream", repo_url)
```
