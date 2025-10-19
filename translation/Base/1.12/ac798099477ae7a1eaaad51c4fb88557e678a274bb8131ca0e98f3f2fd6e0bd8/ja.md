```julia
chopprefix(s::AbstractString, prefix::Union{AbstractString,Regex}) -> SubString
```

`s`から接頭辞`prefix`を削除します。`s`が`prefix`で始まっていない場合、`s`と等しい文字列が返されます。

[`chopsuffix`](@ref)も参照してください。

!!! compat "Julia 1.8"
    この関数はJulia 1.8以降で利用可能です。


# 例

```jldoctest
julia> chopprefix("Hamburger", "Ham")
"burger"

julia> chopprefix("Hamburger", "hotdog")
"Hamburger"
```
