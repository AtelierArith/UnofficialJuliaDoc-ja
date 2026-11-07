```julia
open(command, mode::AbstractString, stdio=devnull)
```

`command`を非同期で実行します。`open(command, stdio; read, write)`と似ていますが、キーワード引数ではなくモード文字列で読み取りフラグと書き込みフラグを指定します。指定できるモード文字列は次のとおりです。

| モード  | 説明        | キーワード                       |
|:---- |:--------- |:--------------------------- |
| `r`  | 読み取り      | なし                          |
| `w`  | 書き込み      | `write = true`              |
| `r+` | 読み取り、書き込み | `read = true, write = true` |
| `w+` | 読み取り、書き込み | `read = true, write = true` |
