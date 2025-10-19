```julia
fetch_refspecs(rmt::GitRemote) -> Vector{String}
```

指定された `rmt` の *fetch* refspecs を取得します。これらの refspecs には、どのブランチを取得するかに関する情報が含まれています。

# 例

```julia-repl
julia> remote = LibGit2.get(LibGit2.GitRemote, repo, "upstream");

julia> LibGit2.add_fetch!(repo, remote, "upstream");

julia> LibGit2.fetch_refspecs(remote)
String["+refs/heads/*:refs/remotes/upstream/*"]
```
