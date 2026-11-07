```julia
name(rmt::GitRemote)
```

リモートリポジトリの名前を取得します。たとえば、`"origin"`です。リモートが匿名の場合（[`GitRemoteAnon`](@ref)を参照）、名前は空文字列`""`になります。

# Examples

```julia-repl
julia> repo_url = "https://github.com/JuliaLang/Example.jl";

julia> repo = LibGit2.clone(cache_repo, "test_directory");

julia> remote = LibGit2.GitRemote(repo, "origin", repo_url);

julia> name(remote)
"origin"
```
