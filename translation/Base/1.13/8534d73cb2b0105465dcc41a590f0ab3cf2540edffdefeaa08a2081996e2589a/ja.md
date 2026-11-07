```julia
ctruncate(str::AbstractString, maxwidth::Integer, replacement::Union{AbstractString,AbstractChar} = '…'; prefer_left::Bool = true)
```

`str` を最大 `maxwidth` 列（[`textwidth`](@ref) による推定）に切り詰めます。必要に応じて中央の文字を `replacement` に置き換えます。デフォルトの置換文字列は「…」です。デフォルトでは左側の文字を優先して残しますが、`prefer_left` を `false` に設定すると変更できます。

# Examples

```jldoctest
julia> s = ctruncate("🍕🍕 I love 🍕", 10)
"🍕🍕 …e 🍕"

julia> textwidth(s)
10

julia> ctruncate("foo", 3)
"foo"
```

!!! compat "Julia 1.12"
    この関数は Julia 1.12 で追加されました。


[`ltruncate`](@ref) および [`rtruncate`](@ref) も参照してください。
