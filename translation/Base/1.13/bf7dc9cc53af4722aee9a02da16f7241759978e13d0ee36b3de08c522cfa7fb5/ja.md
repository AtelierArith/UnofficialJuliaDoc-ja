```julia
displaysize([io::IO]) -> (lines, columns)
```

この `IO` オブジェクトの出力をレンダリングする際に使用できる、画面の公称サイズを返します。入力が指定されていない場合は、環境変数 `LINES` と `COLUMNS` を読み取ります。これらが設定されていない場合は、デフォルトサイズ `(24, 80)` を返します。

# Examples

```jldoctest
julia> withenv("LINES" => 30, "COLUMNS" => 100) do
           displaysize()
       end
(30, 100)
```

TTY のサイズを取得するには、

```julia-repl
julia> displaysize(stdout)
(34, 147)
```
