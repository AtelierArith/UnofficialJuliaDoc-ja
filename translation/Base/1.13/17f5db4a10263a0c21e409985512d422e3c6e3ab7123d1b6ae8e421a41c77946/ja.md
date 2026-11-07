```julia
unmark(s::IO)
```

ストリーム `s` からマークを削除します。ストリームにマークが付いていた場合は `true` を、そうでない場合は `false` を返します。

[`mark`](@ref)、[`reset`](@ref)、[`ismarked`](@ref) も参照してください。
