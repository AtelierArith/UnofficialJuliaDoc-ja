```julia
GitRemote(repo::GitRepo, rmt_name::AbstractString, rmt_url::AbstractString, fetch_spec::AbstractString) -> GitRemote
```

リモートのgitリポジトリを、リポジトリの名前とURL、およびリモートからの取得方法の仕様（例：どのリモートブランチから取得するか）を使用して検索します。

# 例

```julia
repo = LibGit2.init(repo_path)
refspec = "+refs/heads/mybranch:refs/remotes/origin/mybranch"
remote = LibGit2.GitRemote(repo, "upstream", repo_url, refspec)
```
