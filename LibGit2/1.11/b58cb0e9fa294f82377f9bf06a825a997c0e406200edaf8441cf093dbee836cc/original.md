```julia
transact(f::Function, repo::GitRepo)
```

Apply function `f` to the git repository `repo`, taking a [`snapshot`](@ref) before applying `f`. If an error occurs within `f`, `repo` will be returned to its snapshot state using [`restore`](@ref). The error which occurred will be rethrown, but the state of `repo` will not be corrupted.
