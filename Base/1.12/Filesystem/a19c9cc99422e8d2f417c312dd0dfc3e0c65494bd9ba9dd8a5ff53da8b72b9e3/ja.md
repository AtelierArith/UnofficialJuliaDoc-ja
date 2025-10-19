```julia
expanduser(path::AbstractString) -> AbstractString
```

Unixシステムでは、パスの先頭にあるチルダ文字を現在のユーザーのホームディレクトリに置き換えます。

参照: [`contractuser`](@ref).
