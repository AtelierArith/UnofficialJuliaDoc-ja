```julia
windowserror(sysfunc[, code::UInt32=Libc.GetLastError()])
windowserror(sysfunc, iftrue::Bool)
```

[`systemerror`](@ref)と同様ですが、[`errno`](@ref Base.Libc.errno)を設定する代わりに、[`GetLastError`](@ref Base.Libc.GetLastError)を使ってエラーコードを返すWindows API関数向けです。
