```julia
add_fetch!(repo::GitRepo, rmt::GitRemote, fetch_spec::String)
```

指定された `rmt` のために *fetch* refspec を追加します。この refspec には、どのブランチを取得するかに関する情報が含まれます。

# 例

```julia-repl
julia> LibGit2.add_fetch!(repo, remote, "upstream");

julia> LibGit2.fetch_refspecs(remote)
String["+refs/heads/*:refs/remotes/upstream/*"]
```
