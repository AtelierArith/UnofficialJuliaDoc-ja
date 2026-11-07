```julia
is_ancestor_of(a::AbstractString, b::AbstractString, repo::GitRepo)::Bool
```

`true`を返すのは、文字列形式の[`GitHash`](@ref)である`a`が、文字列形式の[`GitHash`](@ref)である`b`の祖先である場合です。

# Examples

```julia-repl
julia> repo = GitRepo(repo_path);

julia> LibGit2.add!(repo, test_file1);

julia> commit_oid1 = LibGit2.commit(repo, "commit1");

julia> LibGit2.add!(repo, test_file2);

julia> commit_oid2 = LibGit2.commit(repo, "commit2");

julia> LibGit2.is_ancestor_of(string(commit_oid1), string(commit_oid2), repo)
true
```
