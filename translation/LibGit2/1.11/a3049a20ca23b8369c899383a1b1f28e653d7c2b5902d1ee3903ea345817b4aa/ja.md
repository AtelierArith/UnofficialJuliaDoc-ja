```julia
GitRemoteAnon(repo::GitRepo, url::AbstractString)::GitRemote
```

名前ではなく、URLだけを使ってリモートのGitリポジトリを検索します。

# Examples

```julia
repo = LibGit2.init(repo_path)
remote = LibGit2.GitRemoteAnon(repo, repo_url)
```
