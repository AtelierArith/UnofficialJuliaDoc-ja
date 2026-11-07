```julia
lookup_remote(repo::GitRepo, remote_name::AbstractString)::Union{GitRemote, Nothing}
```

指定された`remote_name`が`repo`内に存在するかどうかを判定します。存在する場合はリモート名への[`GitRemote`](@ref)を、存在しない場合は[`nothing`](@ref)を返します。

# Examples

```julia
repo = LibGit2.GitRepo(path)
remote_name = "test"
LibGit2.lookup_remote(repo, remote_name) # will return nothing
```
