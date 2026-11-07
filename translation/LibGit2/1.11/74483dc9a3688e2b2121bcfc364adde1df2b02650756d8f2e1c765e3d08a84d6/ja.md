```julia
files_changed(diff_stat::GitDiffStats)::Csize_t
```

[`GitDiff`](@ref)で変更されたファイル（追加・変更・削除）の数を、`diff_stat`で要約して返します。結果は、`diff_stat`の親`GitDiff`を生成する際に使用した[`DiffOptionsStruct`](@ref)によって異なる場合があります（たとえば、無視対象のファイルを含めるかどうかなど）。
