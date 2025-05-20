```
displaysize([io::IO]) -> (lines, columns)
```

この `IO` オブジェクトに出力をレンダリングするために使用できる画面の名目サイズを返します。入力が提供されていない場合、環境変数 `LINES` と `COLUMNS` が読み取られます。それらが設定されていない場合、デフォルトサイズ `(24, 80)` が返されます。

# 例

```jldoctest
julia> withenv("LINES" => 30, "COLUMNS" => 100) do
           displaysize()
       end
(30, 100)
```

TTYサイズを取得するには、

```julia-repl
julia> displaysize(stdout)
(34, 147)
```
