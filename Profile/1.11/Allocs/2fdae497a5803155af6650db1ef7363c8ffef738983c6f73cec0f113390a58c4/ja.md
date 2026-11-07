```julia
Profile.Allocs.print([io::IO = stdout,] [data::AllocResults = fetch()]; kwargs...)
```

プロファイリング結果を`io`に出力します（デフォルトは`stdout`）。`data`ベクトルを指定しない場合は、蓄積されたバックトレースを格納する内部バッファが使用されます。

有効なキーワード引数については、`Profile.print`を参照してください。
