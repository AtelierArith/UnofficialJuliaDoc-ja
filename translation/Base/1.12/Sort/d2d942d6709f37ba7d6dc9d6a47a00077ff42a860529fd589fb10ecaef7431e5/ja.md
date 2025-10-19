```julia
partialsort(v, k, by=identity, lt=isless, rev=false)
```

[`partialsort!`](@ref) のバリアントで、部分的にソートする前に `v` をコピーし、`partialsort!` と同じものを返しますが、`v` は変更されません。
