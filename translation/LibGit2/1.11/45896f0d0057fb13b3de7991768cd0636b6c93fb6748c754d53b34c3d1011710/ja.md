```julia
GitRemoteAnon(repo::GitRepo, url::AbstractString) -> GitRemote
```

名前ではなく、URLのみを使用してリモートgitリポジトリを検索します。

# 例

```julia
repo = LibGit2.init(repo_path)
remote = LibGit2.GitRemoteAnon(repo, repo_url)
```
