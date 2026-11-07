```julia
LibGit2.shortname(ref::GitReference)
```

`ref` の名前を短縮した、人が読みやすい形式で返します。

```julia-repl
julia> repo = GitRepo(path_to_repo);

julia> branch_ref = LibGit2.head(repo);

julia> LibGit2.name(branch_ref)
"refs/heads/master"

julia> LibGit2.shortname(branch_ref)
"master"
```
