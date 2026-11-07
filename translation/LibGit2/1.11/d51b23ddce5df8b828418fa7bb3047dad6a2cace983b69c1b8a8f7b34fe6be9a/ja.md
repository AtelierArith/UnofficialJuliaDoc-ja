```julia
GitRemote(repo::GitRepo, rmt_name::AbstractString, rmt_url::AbstractString, fetch_spec::AbstractString)::GitRemote
```

リポジトリ名とURL、およびリモートからの取得方法に関する指定（取得元のリモートブランチなど）を使って、リモートのGitリポジトリを検索します。

# Examples

```julia
repo = LibGit2.init(repo_path)
refspec = "+refs/heads/mybranch:refs/remotes/origin/mybranch"
remote = LibGit2.GitRemote(repo, "upstream", repo_url, refspec)
```
