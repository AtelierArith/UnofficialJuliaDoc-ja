```julia
print([io::IO = stdout,] [data::Vector = fetch()], [lidict::Union{LineInfoDict, LineInfoFlatDict} = getdict(data)]; kwargs...)
print(path::String, [cols::Int = 1000], [data::Vector = fetch()], [lidict::Union{LineInfoDict, LineInfoFlatDict} = getdict(data)]; kwargs...)
```

`io` にプロファイリング結果を出力します（デフォルトは `stdout`）。`data` ベクターを提供しない場合、蓄積されたバックトレースの内部バッファが使用されます。パスはサポートされているターミナルでクリック可能なリンクであり、行番号付きの [`JULIA_EDITOR`](@ref) に特化されているか、エディタが設定されていない場合はファイルリンクのみです。

キーワード引数は任意の組み合わせが可能です：

  * `format` – バックトレースがインデント付き（デフォルト、`:tree`）またはインデントなし（`:flat`）で表示されるかどうかを決定します。
  * `C` – `true` の場合、C および Fortran コードからのバックトレースが表示されます（通常は除外されます）。
  * `combine` – `true`（デフォルト）の場合、同じ行のコードに対応する命令ポインタがマージされます。
  * `maxdepth` – `:tree` 形式で `maxdepth` より深い深さを制限します。
  * `sortedby` – `:flat` 形式での順序を制御します。`:filefuncline`（デフォルト）はソース行でソートし、`:count` は収集されたサンプルの数の順にソートし、`:overhead` は各関数によって発生したサンプルの数でソートします。
  * `groupby` – タスクとスレッドのグループ化を制御します。オプションは `:none`（デフォルト）、`:thread`、`:task`、`[:thread, :task]`、または `[:task, :thread]` で、最後の2つはネストされたグループ化を提供します。
  * `noisefloor` – サンプルのヒューリスティックノイズフロアを超えるフレームを制限します（`:tree` 形式にのみ適用されます）。これに対して試すべき推奨値は 2.0 です（デフォルトは 0）。このパラメータは、`n <= noisefloor * √N` の場合にサンプルを隠します。ここで、`n` はこの行のサンプル数、`N` は呼び出し元のサンプル数です。
  * `mincount` – 出力を `mincount` 回以上の出現がある行のみに制限します。
  * `recur` – `:tree` 形式での再帰処理を制御します。`:off`（デフォルト）はツリーを通常通り表示します。`:flat` は再帰を圧縮し（ip によって）、自己再帰をイテレータに変換した場合の近似効果を示します。`:flatc` は同様のことを行いますが、C フレームの圧縮も含まれます（`jl_apply` の周りで奇妙なことが起こる可能性があります）。
  * `threads::Union{Int,AbstractVector{Int}}` – レポートにスナップショットを含めるスレッドを指定します。これは、サンプルが収集されるスレッドを制御するものではありません（別のマシンで収集された可能性もあります）。
  * `tasks::Union{Int,AbstractVector{Int}}` – レポートにスナップショットを含めるタスクを指定します。これは、サンプルが収集されるタスクを制御するものではありません。

!!! compat "Julia 1.8"
    `groupby`、`threads`、および `tasks` キーワード引数は Julia 1.8 で導入されました。


!!! note
    Windows でのプロファイリングはメインスレッドに制限されています。他のスレッドはサンプリングされておらず、レポートには表示されません。

