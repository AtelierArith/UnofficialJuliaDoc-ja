```
find_artifacts_toml(path::String)
```

与えられた`.jl`ファイルへのパス（マクロコンテキストで`__source__.file`によって返されるものなど）に基づいて、含まれているプロジェクト内の`(Julia)Artifacts.toml`を見つけます（存在する場合）。そうでない場合は`nothing`を返します。

!!! compat "Julia 1.3"
    この関数は少なくともJulia 1.3が必要です。

