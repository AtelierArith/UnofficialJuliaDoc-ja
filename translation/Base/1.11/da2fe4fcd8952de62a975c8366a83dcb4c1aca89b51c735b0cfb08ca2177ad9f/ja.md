```
chopsuffix(s::AbstractString, suffix::Union{AbstractString,Regex}) -> SubString
```

`s`から接尾辞`suffix`を削除します。`s`が`suffix`で終わっていない場合、`s`と等しい文字列が返されます。

[`chopprefix`](@ref)も参照してください。

!!! compat "Julia 1.8"
    この関数はJulia 1.8以降で利用可能です。


# 例

```jldoctest
julia> chopsuffix("Hamburger", "er")
"Hamburg"

julia> chopsuffix("Hamburger", "hotdog")
"Hamburger"
```
