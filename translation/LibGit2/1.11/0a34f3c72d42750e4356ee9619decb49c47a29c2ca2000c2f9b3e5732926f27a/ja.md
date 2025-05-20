```
set_remote_push_url(repo::GitRepo, remote_name, url)
set_remote_push_url(path::String, remote_name, url)
```

指定された `remote_name` のプッシュ `url` を [`GitRepo`](@ref) または `path` にある git リポジトリのために設定します。通常、git リポジトリはリモート名として `"origin"` を使用します。
