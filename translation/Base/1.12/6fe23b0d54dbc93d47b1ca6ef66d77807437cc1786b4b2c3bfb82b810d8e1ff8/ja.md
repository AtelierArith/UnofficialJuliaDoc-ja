```julia
ltruncate(str::AbstractString, maxwidth::Integer, replacement::Union{AbstractString,AbstractChar} = '…')
```

`str`を最大で`maxwidth`列に切り詰めます（[`textwidth`](@ref)によって推定される）、必要に応じて最初の文字を`replacement`で置き換えます。デフォルトの置き換え文字列は"…"です。

# 例

```jldoctest
julia> s = ltruncate("🍕🍕 I love 🍕", 10)
"…I love 🍕"

julia> textwidth(s)
10

julia> ltruncate("foo", 3)
"foo"
```

!!! compat "Julia 1.12"
    この関数はJulia 1.12で追加されました。


他に[`rtruncate`](@ref)や[`ctruncate`](@ref)も参照してください。
