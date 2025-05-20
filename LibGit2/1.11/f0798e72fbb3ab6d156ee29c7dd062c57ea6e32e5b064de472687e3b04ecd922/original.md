```
lookup_remote(repo::GitRepo, remote_name::AbstractString) -> Union{GitRemote, Nothing}
```

Determine if the `remote_name` specified exists within the `repo`. Return either a [`GitRemote`](@ref) to the remote name if it exists, or [`nothing`](@ref) if not.

# Examples

```julia
repo = LibGit2.GitRepo(path)
remote_name = "test"
LibGit2.lookup_remote(repo, remote_name) # will return nothing
```
