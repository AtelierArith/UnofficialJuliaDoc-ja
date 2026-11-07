```julia
update!(hist::HistoryFile) -> HistoryFile
```

履歴ファイルから新しいエントリを読み込み、`HistEntry`として記録します。

形式が不正なエントリはスキップされます。最後のエントリが不完全な場合、IO位置はそのエントリの先頭に戻されます。
