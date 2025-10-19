```julia
windowserror(sysfunc[, code::UInt32=Libc.GetLastError()])
windowserror(sysfunc, iftrue::Bool)
```

[`systemerror`](@ref)と同様ですが、[`GetLastError`](@ref Base.Libc.GetLastError)を使用してエラーコードを返すWindows API関数用であり、[`errno`](@ref Base.Libc.errno)を設定するのではありません。
