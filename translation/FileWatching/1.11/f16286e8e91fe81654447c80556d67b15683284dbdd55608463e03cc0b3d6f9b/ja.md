```julia
poll_file(path::AbstractString, interval_s::Real=5.007, timeout_s::Real=-1) -> (previous::StatStruct, current)
```

ファイルに変更があったかどうかを、`interval_s` 秒ごとにポーリングして監視します。変更が検出されるか、`timeout_s` 秒が経過すると監視を終了します。`interval_s` は長めの時間に設定してください。デフォルトは 5.007 秒です。

変更が検出されると、ステータスオブジェクトのペア `(previous, current)` を返します。`previous` のステータスは常に `StatStruct` ですが、すべてのフィールドがゼロになっている場合があります（ファイルが以前は存在しなかった、またはアクセスできなかったことを示します）。

`current` のステータスオブジェクトは、`StatStruct`、`EOFError`（タイムアウトが経過したことを示します）、またはその他の `Exception` サブタイプ（`stat` 操作が失敗した場合。たとえば、パスが存在しない場合）になることがあります。

ファイルがいつ変更されたかを判定するには、`!(current isa StatStruct && prev == current)` を比較して、mtime または inode の変更通知を検出します。ただし、この操作には [`watch_file`](@ref) を使うことを推奨します。こちらのほうが信頼性と効率に優れていますが、状況によっては利用できない場合があります。

これは、機能を実装する [`PollingFileWatcher`](@ref) 上で `wait` を呼び出す薄いラッパーです。ただし、この関数では `poll_file` の連続した呼び出しの間に小さな競合ウィンドウがあり、その間にファイルが変更されても検出されない可能性があります。
