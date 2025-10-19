```julia
rtruncate(str::AbstractString, maxwidth::Integer, replacement::Union{AbstractString,AbstractChar} = '…')
```

`str`を最大で`maxwidth`列に切り詰めます（[`textwidth`](@ref)によって推定されるように）、必要に応じて最後の文字を`replacement`で置き換えます。デフォルトの置き換え文字列は"…"です。

# 例

```jldoctest
julia> s = rtruncate("🍕🍕 I love 🍕", 10)
"🍕🍕 I lo…"

julia> textwidth(s)
10

julia> rtruncate("foo", 3)
"foo"
```

!!! compat "Julia 1.12"
    この関数はJulia 1.12で追加されました。


[`ltruncate`](@ref)および[`ctruncate`](@ref)も参照してください。
