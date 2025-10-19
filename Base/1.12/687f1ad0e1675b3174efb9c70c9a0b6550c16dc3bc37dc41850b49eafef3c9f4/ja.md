```julia
open(filename::AbstractString; lock = true, keywords...) -> IOStream
```

ファイルを5つのブールキーワード引数で指定されたモードで開きます：

| キーワード      | 説明           | デフォルト                                 |
|:---------- |:------------ |:------------------------------------- |
| `read`     | 読み取り用に開く     | `!write`                              |
| `write`    | 書き込み用に開く     | `truncate \| append`                  |
| `create`   | 存在しない場合は作成   | `!read & write \| truncate \| append` |
| `truncate` | サイズをゼロに切り詰める | `!read & write`                       |
| `append`   | 終端にシークする     | `false`                               |

キーワードが渡されない場合のデフォルトは、ファイルを読み取り専用で開くことです。開かれたファイルにアクセスするためのストリームを返します。

`lock`キーワード引数は、操作が安全なマルチスレッドアクセスのためにロックされるかどうかを制御します。

!!! compat "Julia 1.5"
    `lock`引数はJulia 1.5以降で利用可能です。

