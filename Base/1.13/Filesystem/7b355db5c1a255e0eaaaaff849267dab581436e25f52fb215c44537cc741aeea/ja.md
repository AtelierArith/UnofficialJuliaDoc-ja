```julia
expanduser(path::AbstractString)::AbstractString
```

Unix システムでは、パスの先頭にあるチルダ文字を、現在のユーザーのホームディレクトリに置き換えます。

関連項目: [`contractuser`](@ref)。
