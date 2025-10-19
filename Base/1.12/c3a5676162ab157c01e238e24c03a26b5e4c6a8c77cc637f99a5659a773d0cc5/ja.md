```julia
rpad(s, n::Integer, p::Union{AbstractChar,AbstractString}=' ') -> String
```

`s`を文字列に変換し、結果の文字列を右側に`p`でパディングして`n`文字（[`textwidth`](@ref)）の長さにします。もし`s`がすでに`n`文字の長さであれば、同じ文字列が返されます。デフォルトではスペースでパディングします。

# 例

```jldoctest
julia> rpad("March", 20)
"March               "
```

!!! compat "Julia 1.7"
    Julia 1.7では、この関数は生の文字（コードポイント）カウントではなく`textwidth`を使用するように変更されました。

