```julia
deletions(diff_stat::GitDiffStats)::Csize_t
```

`diff_stat`で要約された[`GitDiff`](@ref)内の削除数（削除された行数）の合計を返します。この結果は、`diff_stat`の親である`GitDiff`の生成に使用した[`DiffOptionsStruct`](@ref)によって異なる場合があります（たとえば、無視対象のファイルを含めるかどうか）。
