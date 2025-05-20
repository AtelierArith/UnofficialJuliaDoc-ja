```
set_remote_fetch_url(repo::GitRepo, remote_name, url)
set_remote_fetch_url(path::String, remote_name, url)
```

Set the fetch `url` for the specified `remote_name` for the [`GitRepo`](@ref) or the git repository located at `path`. Typically git repos use `"origin"` as the remote name.
