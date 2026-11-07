```julia
ctime(path)
ctime(path_elements...)
ctime(stat_struct)
```

`path` にあるファイルのメタデータが最後に変更された時刻、またはファイル記述子 `stat_struct` が示すメタデータの最終変更時刻を、Unix タイムスタンプで返します。

`stat(path).ctime` または `stat_struct.ctime` と同等です。
