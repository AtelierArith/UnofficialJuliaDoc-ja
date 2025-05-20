```
lookup_remote(repo::GitRepo, remote_name::AbstractString) -> Union{GitRemote, Nothing}
```

指定された `remote_name` が `repo` 内に存在するかどうかを判断します。存在する場合はリモート名に対する [`GitRemote`](@ref) を返し、存在しない場合は [`nothing`](@ref) を返します。

# 例

```julia
repo = LibGit2.GitRepo(path)
remote_name = "test"
LibGit2.lookup_remote(repo, remote_name) # 何も返しません
```
