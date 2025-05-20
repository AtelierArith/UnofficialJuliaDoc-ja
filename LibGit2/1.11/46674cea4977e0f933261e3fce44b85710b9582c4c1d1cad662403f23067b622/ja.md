```
GitRemoteAnon(repo::GitRepo, url::AbstractString) -> GitRemote
```

URLのみを使用してリモートgitリポジトリを検索します。名前ではなく。

# 例

```julia
repo = LibGit2.init(repo_path)
remote = LibGit2.GitRemoteAnon(repo, repo_url)
```
