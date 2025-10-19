```julia
FileMonitor(path::AbstractString)
```

ファイルまたはディレクトリ `path`（存在する必要があります）を変更のために監視します。変更が発生するまでこの関数はファイルシステムをポーリングせず、代わりにプラットフォーム固有の機能を使用してオペレーティングシステムからの通知を受け取ります（例：Linuxのinotifyを介して）。詳細については、以下のNodeJSドキュメントを参照してください。

`fm = FileMonitor(path)` は自動リセットイベントのように動作するため、`wait(fm)` は指定されたパスに元々あったファイルで少なくとも1つのイベントが発生するまでブロックし、その後、最後の `wait` 呼び出しから発生したすべての変更を要約するブールフィールド `renamed`、`changed`、`timedout` を持つオブジェクトを返します。

この関数の動作はプラットフォームによってわずかに異なります。詳細な情報については [https://nodejs.org/api/fs.html#fs_caveats](https://nodejs.org/api/fs.html#fs_caveats) を参照してください。
