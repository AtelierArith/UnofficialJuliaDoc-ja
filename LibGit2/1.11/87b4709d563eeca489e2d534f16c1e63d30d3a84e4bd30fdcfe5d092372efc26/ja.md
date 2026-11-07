```julia
set_remote_url(repo::GitRepo, remote_name, url)
set_remote_url(repo::String, remote_name, url)
```

[`GitRepo`](@ref)または`path`にあるgitリポジトリの`remote_name`について、fetchとpushの両方を`url`に設定します。通常、gitリポジトリではリモート名に`"origin"`を使用します。

# Examples

```julia
repo_path = joinpath(tempdir(), "Example")
repo = LibGit2.init(repo_path)
LibGit2.set_remote_url(repo, "upstream", "https://github.com/JuliaLang/Example.jl")
LibGit2.set_remote_url(repo_path, "upstream2", "https://github.com/JuliaLang/Example2.jl")
```
