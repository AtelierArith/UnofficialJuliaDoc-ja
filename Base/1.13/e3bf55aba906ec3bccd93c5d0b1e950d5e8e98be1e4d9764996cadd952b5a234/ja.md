```julia
systemerror(sysfunc[, errno::Cint=Libc.errno()])
systemerror(sysfunc, iftrue::Bool)
```

`iftrue` が `true` の場合、説明文字列 `sysfunc` を指定して、`errno` に対する `SystemError` を発生させます。
