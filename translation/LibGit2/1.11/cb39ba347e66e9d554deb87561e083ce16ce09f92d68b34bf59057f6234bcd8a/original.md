```julia
lookup_branch(repo::GitRepo, branch_name::AbstractString, remote::Bool=false) -> Union{GitReference, Nothing}
```

Determine if the branch specified by `branch_name` exists in the repository `repo`. If `remote` is `true`, `repo` is assumed to be a remote git repository. Otherwise, it is part of the local filesystem.

Return either a `GitReference` to the requested branch if it exists, or [`nothing`](@ref) if not.
