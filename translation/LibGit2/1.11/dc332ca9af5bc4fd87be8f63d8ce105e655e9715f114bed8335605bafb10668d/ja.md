```julia
add_fetch!(repo::GitRepo, rmt::GitRemote, fetch_spec::String)
```

指定した`rmt`に対する *fetch* refspec を追加します。この refspec には、どのブランチをフェッチするかを示す情報が含まれます。

# Examples

```julia-repl
julia> LibGit2.add_fetch!(repo, remote, "upstream");

julia> LibGit2.fetch_refspecs(remote)
String["+refs/heads/*:refs/remotes/upstream/*"]
```
