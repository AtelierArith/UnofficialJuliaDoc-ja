```julia
splitdrive(path::AbstractString) -> (AbstractString, AbstractString)
```

Windowsでは、パスをドライブレター部分とパス部分に分割します。Unixシステムでは、最初のコンポーネントは常に空の文字列です。
