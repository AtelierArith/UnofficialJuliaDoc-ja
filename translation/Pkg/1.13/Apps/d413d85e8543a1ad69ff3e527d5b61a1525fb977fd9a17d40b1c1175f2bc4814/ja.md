```julia
Pkg.Apps.add(pkg::Union{String, PackageSpec})
Pkg.Apps.add(; name, uuid, version, url, rev, path, subdir)
```

パッケージ `pkg` のアプリをインストールします。パッケージは隔離された環境にインストールされ、アプリのシムは `~/.julia/bin` に作成されます（このディレクトリは `PATH` に追加してください）。アプリはレジストリ、Git URL、またはローカルパスから追加できます（ローカルパスの場合は、Git リポジトリである必要があります）。

# Examples

```julia
Pkg.Apps.add("Runic")
Pkg.Apps.add(name = "Runic", version = "1.5")
Pkg.Apps.add(url = "https://github.com/fredrikekre/Runic.jl", rev = "master")
Pkg.Apps.add(path = "path/to/Package")
```
