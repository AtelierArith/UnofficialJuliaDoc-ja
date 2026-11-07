```julia
set_remote_push_url(repo::GitRepo, remote_name, url)
set_remote_push_url(path::String, remote_name, url)
```

[`GitRepo`](@ref) または `path` にある Git リポジトリに対して、指定した `remote_name` の push `url` を設定します。通常、Git リポジトリではリモート名に `"origin"` を使用します。
