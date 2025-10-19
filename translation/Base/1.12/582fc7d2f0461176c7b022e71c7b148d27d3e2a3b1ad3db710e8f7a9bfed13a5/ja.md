```julia
unmark(s::IO)
```

ストリーム`s`からマークを削除します。ストリームがマークされていた場合は`true`を返し、そうでない場合は`false`を返します。

他にも[`mark`](@ref)、[`reset`](@ref)、[`ismarked`](@ref)を参照してください。
