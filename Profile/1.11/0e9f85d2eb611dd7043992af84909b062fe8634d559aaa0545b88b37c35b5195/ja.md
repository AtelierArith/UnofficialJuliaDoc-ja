```julia
print([io::IO = stdout,] data::Vector, lidict::LineInfoDict; kwargs...)
```

プロファイリング結果を`io`に出力します。このバリアントは、以前の[`retrieve`](@ref)の呼び出しでエクスポートされた結果を調べるために使用します。バックトレースのベクター`data`と、行情報の辞書`lidict`を指定してください。

有効なキーワード引数については、`Profile.print([io], data)`を参照してください。
