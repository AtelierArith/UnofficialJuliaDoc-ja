```julia
mtime(path)
mtime(path_elements...)
mtime(stat_struct)
```

`path` にあるファイルの最終更新時刻、またはファイル記述子 `stat_struct` が示す最終更新時刻を、Unixタイムスタンプで返します。

`stat(path).mtime` または `stat_struct.mtime` と同等です。
