```julia
push_refspecs(rmt::GitRemote)::Vector{String}
```

指定した`rmt`の*push* refspecを取得します。これらのrefspecには、どのブランチにプッシュするかを示す情報が含まれています。

# Examples

```julia-repl
julia> remote = LibGit2.get(LibGit2.GitRemote, repo, "upstream");

julia> LibGit2.add_push!(repo, remote, "refs/heads/master");

julia> close(remote);

julia> remote = LibGit2.get(LibGit2.GitRemote, repo, "upstream");

julia> LibGit2.push_refspecs(remote)
String["refs/heads/master"]
```
