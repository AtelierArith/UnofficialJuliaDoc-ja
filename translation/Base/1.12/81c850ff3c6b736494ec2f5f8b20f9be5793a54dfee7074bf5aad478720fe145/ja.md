```julia
open(command, mode::AbstractString, stdio=devnull)
```

`command`を非同期で実行します。`open(command, stdio; read, write)`のように、キーワード引数の代わりにモード文字列を指定して読み取りおよび書き込みフラグを設定します。可能なモード文字列は次のとおりです：

| モード  | 説明        | キーワード                       |
|:---- |:--------- |:--------------------------- |
| `r`  | 読み取り      | なし                          |
| `w`  | 書き込み      | `write = true`              |
| `r+` | 読み取り、書き込み | `read = true, write = true` |
| `w+` | 読み取り、書き込み | `read = true, write = true` |
