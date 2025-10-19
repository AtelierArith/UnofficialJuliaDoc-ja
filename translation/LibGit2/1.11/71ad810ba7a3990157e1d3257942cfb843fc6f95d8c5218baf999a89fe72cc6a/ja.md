```julia
is_ancestor_of(a::AbstractString, b::AbstractString, repo::GitRepo) -> Bool
```

`a`が`b`の先祖である場合、`true`を返します。`a`は文字列形式の[`GitHash`](@ref)であり、`b`も文字列形式の[`GitHash`](@ref)です。

# 例

```julia-repl
julia> repo = GitRepo(repo_path);

julia> LibGit2.add!(repo, test_file1);

julia> commit_oid1 = LibGit2.commit(repo, "commit1");

julia> LibGit2.add!(repo, test_file2);

julia> commit_oid2 = LibGit2.commit(repo, "commit2");

julia> LibGit2.is_ancestor_of(string(commit_oid1), string(commit_oid2), repo)
true
```
