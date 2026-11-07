```julia
open(filename::AbstractString; lock = true, keywords...)::IOStream
```

5つのブール値キーワード引数で指定したモードでファイルを開きます。

| キーワード      | 説明           | デフォルト                                 |
|:---------- |:------------ |:------------------------------------- |
| `read`     | 読み込み用に開く     | `!write`                              |
| `write`    | 書き込み用に開く     | `truncate \| append`                  |
| `create`   | 存在しない場合に作成   | `!read & write \| truncate \| append` |
| `truncate` | サイズをゼロに切り詰める | `!read & write`                       |
| `append`   | ファイル末尾に移動    | `false`                               |

キーワード引数を指定しない場合、ファイルは読み込み専用で開かれます。開いたファイルにアクセスするためのストリームを返します。

`lock`キーワード引数は、マルチスレッド環境で安全にアクセスできるよう、操作をロックするかどうかを制御します。

!!! compat "Julia 1.5"
    `lock`引数はJulia 1.5以降で使用できます。

