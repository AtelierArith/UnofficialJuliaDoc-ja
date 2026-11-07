```julia
mkfifo(path::AbstractString, [mode::Integer]) -> path
```

`path` に FIFO 特殊ファイル（名前付きパイプ）を作成します。成功した場合は、`path` をそのまま返します。

`mkfifo` は Unix プラットフォームでのみサポートされています。

!!! compat "Julia 1.11"
    `mkfifo` を使用するには、Julia 1.11 以降が必要です。

