```
windowserror(sysfunc[, code::UInt32=Libc.GetLastError()])
windowserror(sysfunc, iftrue::Bool)
```

[`systemerror`](@ref)と同様ですが、[`errno`](@ref Base.Libc.errno)を設定するのではなく、エラーコードを返すために[`GetLastError`](@ref Base.Libc.GetLastError)を使用するWindows API関数用です。
