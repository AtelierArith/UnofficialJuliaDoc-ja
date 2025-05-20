```
clone(repo_url::AbstractString, repo_path::AbstractString, clone_opts::CloneOptions)
```

リモートリポジトリ `repo_url`（リモートURLまたはローカルファイルシステム上のパスのいずれか）を `repo_path`（ローカルファイルシステム上のパスでなければなりません）にクローンします。ベアクローンを行うかどうかなど、クローンのオプションは [`CloneOptions`](@ref) で設定されます。

# 例

```julia
repo_url = "https://github.com/JuliaLang/Example.jl"
repo = LibGit2.clone(repo_url, "/home/me/projects/Example")
```
