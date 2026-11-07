```julia
Pkg.Apps.status(name::Union{Nothing, String} = nothing)
```

インストール済みのアプリ、各アプリのパッケージバージョン、および実行に使用する julia コマンドを表示します。`name` が指定されている場合は、そのアプリまたはパッケージに出力を限定します。
