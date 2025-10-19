```julia
ctime(path)
ctime(path_elements...)
ctime(stat_struct)
```

ファイルのメタデータが最後に変更された時刻のUnixタイムスタンプを返します。これは、`path`で指定されたファイルのメタデータ、またはファイルディスクリプタ`stat_struct`によって示される最後に変更されたメタデータのタイムスタンプです。

`stat(path).ctime`または`stat_struct.ctime`に相当します。
