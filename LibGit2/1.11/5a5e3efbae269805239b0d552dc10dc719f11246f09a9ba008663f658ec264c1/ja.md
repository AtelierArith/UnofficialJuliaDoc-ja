```
deletions(diff_stat::GitDiffStats) -> Csize_t
```

[`GitDiff`](@ref) によって要約された `diff_stat` の削除行数（削除された行の合計）を返します。結果は、`diff_stat` の親 `GitDiff` を生成するために使用された [`DiffOptionsStruct`](@ref) によって異なる場合があります（たとえば、無視されたファイルを含めるかどうか）。
