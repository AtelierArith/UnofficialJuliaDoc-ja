```
watch_file(path::AbstractString, timeout_s::Real=-1)
```

ファイルまたはディレクトリ `path` の変更を監視し、変更が発生するか `timeout_s` 秒が経過するまで待機します。この関数はファイルシステムをポーリングせず、代わりにプラットフォーム固有の機能を使用してオペレーティングシステムからの通知を受け取ります（例：Linuxのinotifyを介して）。詳細については、以下のNodeJSドキュメントを参照してください。

返される値は、ファイルの監視結果を示すブール型フィールド `renamed`、`changed`、および `timedout` を持つオブジェクトです。

この関数の動作はプラットフォームによってわずかに異なります。詳細な情報については [https://nodejs.org/api/fs.html#fs_caveats](https://nodejs.org/api/fs.html#fs_caveats) を参照してください。
