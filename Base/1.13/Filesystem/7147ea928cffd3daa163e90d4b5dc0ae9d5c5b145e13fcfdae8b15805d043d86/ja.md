```julia
filesize(path)
filesize(path_elements...)
filesize(stat_struct)
```

`path` にあるファイルのサイズ、またはファイル記述子 `stat_struct` が示すファイルのサイズを返します。

`stat(path).size` または `stat_struct.size` と同等です。
