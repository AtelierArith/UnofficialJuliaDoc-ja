```
push_url(rmt::GitRemote)
```

リモートgitリポジトリのプッシュURLを取得します。

# 例

```julia-repl
julia> repo_url = "https://github.com/JuliaLang/Example.jl";

julia> repo = LibGit2.init(mktempdir());

julia> LibGit2.set_remote_push_url(repo, "origin", repo_url);

julia> LibGit2.push_url(LibGit2.get(LibGit2.GitRemote, repo, "origin"))
"https://github.com/JuliaLang/Example.jl"
```
