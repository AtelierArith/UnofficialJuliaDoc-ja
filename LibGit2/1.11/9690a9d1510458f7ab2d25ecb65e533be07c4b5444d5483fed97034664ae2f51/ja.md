```
insertions(diff_stat::GitDiffStats) -> Csize_t
```

[`GitDiff`](@ref) によって要約された `diff_stat` の挿入行数（追加された行数）の合計を返します。結果は、`diff_stat` の親 `GitDiff` を生成するために使用された [`DiffOptionsStruct`](@ref) によって異なる場合があります（たとえば、無視されたファイルを含めるかどうか）。
