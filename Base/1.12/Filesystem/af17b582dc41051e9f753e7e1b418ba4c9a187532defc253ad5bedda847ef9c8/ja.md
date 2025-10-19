```julia
contractuser(path::AbstractString) -> AbstractString
```

Unixシステムでは、パスが `homedir()` で始まる場合、それをチルダ文字に置き換えます。

参照: [`expanduser`](@ref).
