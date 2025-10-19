```julia
mtime(path)
mtime(path_elements...)
mtime(stat_struct)
```

指定された `path` のファイルが最後に変更されたときの Unix タイムスタンプを返します。または、ファイルディスクリプタ `stat_struct` によって示された最後の変更タイムスタンプを返します。

`stat(path).mtime` または `stat_struct.mtime` と同等です。
