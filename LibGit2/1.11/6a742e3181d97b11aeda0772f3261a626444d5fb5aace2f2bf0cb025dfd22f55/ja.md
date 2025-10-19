```julia
push_refspecs(rmt::GitRemote) -> Vector{String}
```

指定された `rmt` の *push* refspecs を取得します。これらの refspecs には、プッシュするブランチに関する情報が含まれています。

# 例

```julia-repl
julia> remote = LibGit2.get(LibGit2.GitRemote, repo, "upstream");

julia> LibGit2.add_push!(repo, remote, "refs/heads/master");

julia> close(remote);

julia> remote = LibGit2.get(LibGit2.GitRemote, repo, "upstream");

julia> LibGit2.push_refspecs(remote)
String["refs/heads/master"]
```
