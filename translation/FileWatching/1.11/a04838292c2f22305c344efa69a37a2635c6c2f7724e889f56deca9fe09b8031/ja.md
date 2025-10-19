```julia
watch_folder(path::AbstractString, timeout_s::Real=-1)
```

ファイルまたはディレクトリ `path` の変更を監視し、変更が発生するか `timeout_s` 秒が経過するまで待機します。この関数はファイルシステムをポーリングせず、代わりにプラットフォーム固有の機能を使用してオペレーティングシステムからの通知を受け取ります（例：Linuxのinotifyを介して）。詳細については、以下のNodeJSドキュメントを参照してください。

この関数は、`unwatch_folder` が同じ `path` に対して呼び出されるまで、バックグラウンドで `path` の変更を追跡し続けます。

返される値は、最初のフィールドが変更されたファイルの名前（利用可能な場合）で、2番目のフィールドがイベントを示すブールフィールド `renamed`、`changed`、および `timedout` を持つオブジェクトのペアです。

この関数の動作はプラットフォームによってわずかに異なります。詳細な情報については [https://nodejs.org/api/fs.html#fs_caveats](https://nodejs.org/api/fs.html#fs_caveats) を参照してください。

この関数は、タイムアウトサポートを追加した [`FolderMonitor`](@ref) の `wait` を呼び出すための薄いラッパーです。
