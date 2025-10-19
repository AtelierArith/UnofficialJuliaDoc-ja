```julia
iscommit(id::AbstractString, repo::GitRepo) -> Bool
```

コミット `id`（文字列形式の [`GitHash`](@ref））がリポジトリに存在するかどうかを確認します。

# 例

```julia-repl
julia> repo = GitRepo(repo_path);

julia> LibGit2.add!(repo, test_file);

julia> commit_oid = LibGit2.commit(repo, "add test_file");

julia> LibGit2.iscommit(string(commit_oid), repo)
true
```
