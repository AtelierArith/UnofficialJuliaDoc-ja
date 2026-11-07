```julia
rtruncate(str::AbstractString, maxwidth::Integer, replacement::Union{AbstractString,AbstractChar} = '…')
```

`str` を、（[`textwidth`](@ref) による推定で）最大 `maxwidth` 列に切り詰めます。必要に応じて末尾の文字を `replacement` に置き換えます。デフォルトの置換文字列は「…」です。

# Examples

```jldoctest
julia> s = rtruncate("🍕🍕 I love 🍕", 10)
"🍕🍕 I lo…"

julia> textwidth(s)
10

julia> rtruncate("foo", 3)
"foo"
```

!!! compat "Julia 1.12"
    この関数は Julia 1.12 で追加されました。


[`ltruncate`](@ref) および [`ctruncate`](@ref) も参照してください。
