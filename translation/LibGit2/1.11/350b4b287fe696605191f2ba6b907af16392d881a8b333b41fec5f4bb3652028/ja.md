```
LibGit2.shortname(ref::GitReference)
```

`ref`の短縮版の名前を返します。これは「人間が読みやすい」形式です。

```julia-repl
julia> repo = GitRepo(path_to_repo);

julia> branch_ref = LibGit2.head(repo);

julia> LibGit2.name(branch_ref)
"refs/heads/master"

julia> LibGit2.shortname(branch_ref)
"master"
```
