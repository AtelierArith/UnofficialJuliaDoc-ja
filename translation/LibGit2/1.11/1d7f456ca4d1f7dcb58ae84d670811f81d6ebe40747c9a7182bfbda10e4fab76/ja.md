```julia
add_push!(repo::GitRepo, rmt::GitRemote, push_spec::String)
```

指定した`rmt`に対して、*push* refspecを追加します。このrefspecには、どのブランチをpushするかを指定します。

# Examples

```julia-repl
julia> LibGit2.add_push!(repo, remote, "refs/heads/master");

julia> remote = LibGit2.get(LibGit2.GitRemote, repo, branch);

julia> LibGit2.push_refspecs(remote)
String["refs/heads/master"]
```

!!! note
    push refspecを更新した後、変更を反映させ、[`push`](@ref)の呼び出しを機能させるには、対象の`GitRemote`を[`close`](@ref)してから、再度開く必要がある場合があります。

