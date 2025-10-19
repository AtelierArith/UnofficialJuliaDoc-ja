```julia
ctruncate(str::AbstractString, maxwidth::Integer, replacement::Union{AbstractString,AbstractChar} = '…'; prefer_left::Bool = true)
```

`str`を最大で`maxwidth`列に切り詰めます（[`textwidth`](@ref)によって推定される）、必要に応じて中央の文字を`replacement`で置き換えます。デフォルトの置き換え文字列は"…"です。デフォルトでは、切り詰めは左側の文字を保持することを優先しますが、`prefer_left`を`false`に設定することで変更できます。

# 例

```jldoctest
julia> s = ctruncate("🍕🍕 I love 🍕", 10)
"🍕🍕 …e 🍕"

julia> textwidth(s)
10

julia> ctruncate("foo", 3)
"foo"
```

!!! compat "Julia 1.12"
    この関数はJulia 1.12で追加されました。


[`ltruncate`](@ref)および[`rtruncate`](@ref)も参照してください。
