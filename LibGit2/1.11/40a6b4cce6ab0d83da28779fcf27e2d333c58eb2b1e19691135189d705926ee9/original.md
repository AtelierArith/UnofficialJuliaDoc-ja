```
iscommit(id::AbstractString, repo::GitRepo) -> Bool
```

Check if commit `id` (which is a [`GitHash`](@ref) in string form) is in the repository.

# Examples

```julia-repl
julia> repo = GitRepo(repo_path);

julia> LibGit2.add!(repo, test_file);

julia> commit_oid = LibGit2.commit(repo, "add test_file");

julia> LibGit2.iscommit(string(commit_oid), repo)
true
```
