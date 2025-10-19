```julia
filesize(path)
filesize(path_elements...)
filesize(stat_struct)
```

`path`にあるファイルのサイズ、またはファイルディスクリプタ`stat_struct`によって示されるサイズを返します。

`stat(path).size`または`stat_struct.size`と同等です。
