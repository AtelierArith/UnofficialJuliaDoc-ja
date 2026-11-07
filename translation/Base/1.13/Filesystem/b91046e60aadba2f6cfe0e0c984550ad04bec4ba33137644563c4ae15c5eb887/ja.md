```julia
filemode(path)
filemode(path_elements...)
filemode(stat_struct)
```

`path` にあるファイルのモード、またはファイル記述子 `stat_struct` が示すモードを返します。

`stat(path).mode` または `stat_struct.mode` と同等です。
