```julia
lpad(s, n::Integer, p::Union{AbstractChar,AbstractString}=' ')::String
```

`s`を文字列に変換し、結果の文字列の左側を`p`で埋めて、`n`文字（[`textwidth`](@ref)）にします。`s`がすでに`n`文字の場合は、同じ文字列が返されます。デフォルトでは空白で埋めます。

# Examples

```jldoctest
julia> lpad("March", 10)
"     March"
```

!!! compat "Julia 1.7"
    Julia 1.7では、この関数は生の文字（コードポイント）の数ではなく、`textwidth`を使用するように変更されました。

