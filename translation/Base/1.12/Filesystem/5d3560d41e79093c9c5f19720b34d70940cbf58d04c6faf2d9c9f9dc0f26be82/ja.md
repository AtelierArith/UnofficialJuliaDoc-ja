```julia
filemode(path)
filemode(path_elements...)
filemode(stat_struct)
```

`path`にあるファイルのモード、またはファイルディスクリプタ`stat_struct`によって示されるモードを返します。

`stat(path).mode`または`stat_struct.mode`に相当します。
