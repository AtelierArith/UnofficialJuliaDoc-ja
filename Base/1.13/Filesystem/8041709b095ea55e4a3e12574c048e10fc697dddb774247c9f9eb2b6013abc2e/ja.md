```julia
splitdrive(path::AbstractString) -> (drive::AbstractString, path::AbstractString)
```

Windowsでは、パスをドライブ文字部分とパス部分に分割します。Unixシステムでは、最初の要素は常に空文字列です。
