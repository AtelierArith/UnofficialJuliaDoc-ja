```julia
clone(repo_url::AbstractString, repo_path::AbstractString, clone_opts::CloneOptions)
```

リモートリポジトリ（リモート URL またはローカルファイルシステム上のパス）を `repo_url` から `repo_path`（ローカルファイルシステム上のパスである必要があります）にクローンします。ベアクローンにするかどうかなどのクローンオプションは、[`CloneOptions`](@ref) で設定します。

# Examples

```julia
repo_url = "https://github.com/JuliaLang/Example.jl"
repo = LibGit2.clone(repo_url, "/home/me/projects/Example")
```
