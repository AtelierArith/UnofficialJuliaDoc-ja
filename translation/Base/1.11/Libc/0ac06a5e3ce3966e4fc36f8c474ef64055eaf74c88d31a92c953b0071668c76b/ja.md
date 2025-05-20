```
mkfifo(path::AbstractString, [mode::Integer]) -> path
```

指定された `path` にFIFO特別ファイル（名前付きパイプ）を作成します。成功した場合は `path` をそのまま返します。

`mkfifo` はUnixプラットフォームでのみサポートされています。

!!! compat "Julia 1.11"
    `mkfifo` は少なくともJulia 1.11が必要です。

