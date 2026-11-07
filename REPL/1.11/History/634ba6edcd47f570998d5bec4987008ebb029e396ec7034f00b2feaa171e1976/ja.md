```julia
runsearch() -> (; mode::Union{Symbol, Nothing}, text::String)
```

対話型 REPL 履歴検索インターフェースを起動します。

プロンプトと表示のタスクを開始し、ユーザーが確定または中止するまで待機して、最終的な選択（あれば）を返します。
