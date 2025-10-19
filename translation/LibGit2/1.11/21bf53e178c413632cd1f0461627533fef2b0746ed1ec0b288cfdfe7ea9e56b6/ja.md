```julia
set_remote_url(repo::GitRepo, remote_name, url)
set_remote_url(repo::String, remote_name, url)
```

`remote_name`のフェッチおよびプッシュ`url`を[`GitRepo`](@ref)または`path`にあるgitリポジトリのために設定します。通常、gitリポジトリはリモート名として`"origin"`を使用します。

# 例

```julia
repo_path = joinpath(tempdir(), "Example")
repo = LibGit2.init(repo_path)
LibGit2.set_remote_url(repo, "upstream", "https://github.com/JuliaLang/Example.jl")
LibGit2.set_remote_url(repo_path, "upstream2", "https://github.com/JuliaLang/Example2.jl")
```
