```julia
rpad(s, n::Integer, p::Union{AbstractChar,AbstractString}=' ')::String
```

`s` を文字列に変換し、右側を `p` で埋めて、（[`textwidth`](@ref)）`n` 文字の長さにします。`s` がすでに `n` 文字の長さであれば、同じ文字列を返します。デフォルトでは空白で埋めます。

# Examples

```jldoctest
julia> rpad("March", 20)
"March               "
```

!!! compat "Julia 1.7"
    Julia 1.7 では、この関数は生の文字（コードポイント）の数ではなく、`textwidth` を使うように変更されました。

