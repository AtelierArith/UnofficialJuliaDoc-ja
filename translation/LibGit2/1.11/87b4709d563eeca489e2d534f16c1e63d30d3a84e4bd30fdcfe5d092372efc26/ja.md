```julia
set_remote_url(repo::GitRepo, remote_name, url)
set_remote_url(repo::String, remote_name, url)
```

`remote_name` の [`GitRepo`](@ref)、または `path` にある git リポジトリについて、fetch と push の両方の `url` を設定します。通常、git リポジトリではリモート名に `"origin"` を使います。

# Examples

```julia
repo_path = joinpath(tempdir(), "Example")
repo = LibGit2.init(repo_path)
LibGit2.set_remote_url(repo, "upstream", "https://github.com/JuliaLang/Example.jl")
LibGit2.set_remote_url(repo_path, "upstream2", "https://github.com/JuliaLang/Example2.jl")
```
