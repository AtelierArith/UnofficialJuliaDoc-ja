```
poll_file(path::AbstractString, interval_s::Real=5.007, timeout_s::Real=-1) -> (previous::StatStruct, current)
```

ファイルの変更を監視するために、`interval_s` 秒ごとにポーリングを行い、変更が発生するか `timeout_s` 秒が経過するまで待機します。`interval_s` は長い期間であるべきで、デフォルトは 5.007 秒です。

変更が検出されると、ステータスオブジェクトのペア `(previous, current)` を返します。`previous` ステータスは常に `StatStruct` ですが、すべてのフィールドがゼロに設定されている場合があります（これは、ファイルが以前は存在しなかったか、以前はアクセスできなかったことを示します）。

`current` ステータスオブジェクトは `StatStruct`、`EOFError`（タイムアウトが経過したことを示す）、または他の `Exception` サブタイプ（`stat` 操作が失敗した場合 - 例えば、パスが存在しない場合）である可能性があります。

ファイルがいつ変更されたかを判断するには、`current isa StatStruct && mtime(prev) != mtime(current)` を比較して変更の通知を検出します。ただし、この操作には [`watch_file`](@ref) を使用することが推奨されます。これはより信頼性が高く効率的ですが、状況によっては利用できない場合があります。
