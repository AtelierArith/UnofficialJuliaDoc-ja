```julia
windowserror(sysfunc[, code::UInt32=Libc.GetLastError()])
windowserror(sysfunc, iftrue::Bool)
```

Like [`systemerror`](@ref), but for Windows API functions that use [`GetLastError`](@ref Base.Libc.GetLastError) to return an error code instead of setting [`errno`](@ref Base.Libc.errno).
