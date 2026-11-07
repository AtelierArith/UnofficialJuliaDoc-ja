```julia
print([io::IO = stdout,] [data::Vector = fetch()], [lidict::Union{LineInfoDict, LineInfoFlatDict} = getdict(data)]; kwargs...)
print(path::String, [cols::Int = 1000], [data::Vector = fetch()], [lidict::Union{LineInfoDict, LineInfoFlatDict} = getdict(data)]; kwargs...)
```

プロファイリング結果を`io`（デフォルトでは`stdout`）に出力します。`data`ベクトルを指定しない場合は、蓄積されたバックトレースの内部バッファが使用されます。対応するターミナルではパスがクリック可能なリンクになり、[`JULIA_EDITOR`](@ref)向けに行番号付きで表示されます。エディタが設定されていない場合は、ファイルへのリンクのみが表示されます。

キーワード引数には、次のいずれかを任意に組み合わせて指定できます。

  * `format` – バックトレースを、ツリー構造を示すインデント付き（デフォルトの`:tree`）で表示するか、インデントなし（`:flat`）で表示するかを指定します。
  * `C` – `true`の場合、CおよびFortranコードのバックトレースも表示します（通常は除外されます）。
  * `combine` – `true`（デフォルト）の場合、同じコード行に対応する命令ポインタをまとめます。
  * `maxdepth` – `:tree`形式で、`maxdepth`を超える深さを制限します。
  * `sortedby` – `:flat`形式での並び順を指定します。`:filefuncline`（デフォルト）はソース行順、`:count`は収集されたサンプル数順、`:overhead`は各関数単独で発生したサンプル数順に並べます。
  * `groupby` – タスクやスレッドごとにグループ化するか、グループ化しないかを指定します。選択肢は`:none`（デフォルト）、`:thread`、`:task`、`[:thread, :task]`、`[:task, :thread]`です。最後の2つでは、入れ子状にグループ化されます。
  * `noisefloor` – サンプルのヒューリスティックなノイズフロアを超えるフレームを制限します（`:tree`形式にのみ適用）。試す値としては2.0が推奨されます（デフォルトは0）。このパラメータは、`n <= noisefloor * √N`となるサンプルを非表示にします。ここで、`n`はこの行のサンプル数、`N`は呼び出し先のサンプル数です。
  * `mincount` – `mincount`回以上出現する行だけに出力を制限します。
  * `recur` – `:tree`形式での再帰処理を指定します。`:off`（デフォルト）は通常どおりツリーを出力します。`:flat`は再帰を（ip単位で）圧縮し、自己再帰をイテレータに変換した場合のおおよその効果を示します。`:flatc`も同様ですが、Cフレームの折りたたみも行います（`jl_apply`の周辺では予期しない動作をする場合があります）。
  * `threads::Union{Int,AbstractVector{Int}}` – レポートに含めるスナップショットのスレッドを指定します。サンプルを収集するスレッドを制御するものではない点に注意してください（サンプルは別のマシンで収集されている場合もあります）。
  * `tasks::Union{Int,AbstractVector{Int}}` – レポートに含めるスナップショットのタスクを指定します。サンプルを収集するタスクを制御するものではない点に注意してください。

!!! compat "Julia 1.8"
    `groupby`、`threads`、`tasks`の各キーワード引数は、Julia 1.8で導入されました。


!!! note
    Windowsでのプロファイリングはメインスレッドに限られます。他のスレッドはサンプリングされていないため、レポートには表示されません。

