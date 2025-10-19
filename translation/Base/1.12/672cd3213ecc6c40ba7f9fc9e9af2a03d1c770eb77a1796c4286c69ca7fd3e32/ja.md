```julia
startswith(io::IO, prefix::Union{AbstractString,Base.Chars})
```

`IO` オブジェクトが、文字列、文字、または文字のタプル/ベクター/セットのいずれかであるプレフィックスで始まるかどうかを確認します。詳細は [`peek`](@ref) を参照してください。
