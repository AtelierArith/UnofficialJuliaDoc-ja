```julia
find_artifacts_toml(path::String)
```

`.jl` ファイルのパス（マクロのコンテキストで `__source__.file` が返すパスなど）が与えられた場合、そのファイルを含むプロジェクト内に存在すれば `(Julia)Artifacts.toml` を探して返し、存在しなければ `nothing` を返します。

!!! compat "Julia 1.3"
    この関数を使用するには、Julia 1.3 以降が必要です。

