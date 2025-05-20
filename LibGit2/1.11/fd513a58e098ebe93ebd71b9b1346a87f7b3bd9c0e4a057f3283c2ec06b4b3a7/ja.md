```
files_changed(diff_stat::GitDiffStats) -> Csize_t
```

[`GitDiff`](@ref) によって要約された `diff_stat` で、変更されたファイルの数（追加/修正/削除）を返します。結果は、`diff_stat` の親 `GitDiff` を生成するために使用される [`DiffOptionsStruct`](@ref) によって異なる場合があります（たとえば、無視されたファイルを含めるかどうか）。
