```julia
fetch_refspecs(rmt::GitRemote)::Vector{String}
```

指定した`rmt`の*fetch* refspecを取得します。これらのrefspecには、どのブランチを取得するかを示す情報が含まれています。

# Examples

```julia-repl
julia> remote = LibGit2.get(LibGit2.GitRemote, repo, "upstream");

julia> LibGit2.add_fetch!(repo, remote, "upstream");

julia> LibGit2.fetch_refspecs(remote)
String["+refs/heads/*:refs/remotes/upstream/*"]
```
