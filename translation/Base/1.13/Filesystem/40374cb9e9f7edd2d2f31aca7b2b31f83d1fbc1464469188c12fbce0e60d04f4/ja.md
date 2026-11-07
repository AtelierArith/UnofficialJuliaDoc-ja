```julia
contractuser(path::AbstractString)::AbstractString
```

Unix システムでは、パスが `homedir()` で始まる場合、チルダ文字に置き換えます。

関連項目: [`expanduser`](@ref)。
