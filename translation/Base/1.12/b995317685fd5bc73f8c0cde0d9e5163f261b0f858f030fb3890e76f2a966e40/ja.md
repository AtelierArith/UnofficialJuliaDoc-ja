```julia
isascii(c::Union{AbstractChar,AbstractString}) -> Bool
```

文字がASCII文字セットに属するか、または文字列のすべての要素がそうであるかをテストします。

# 例

```jldoctest
julia> isascii('a')
true

julia> isascii('α')
false

julia> isascii("abc")
true

julia> isascii("αβγ")
false
```

例えば、`isascii`は[`filter`](@ref)や[`replace`](@ref)のための述語関数として使用でき、非ASCII文字をそれぞれ削除または置き換えることができます：

```jldoctest
julia> filter(isascii, "abcdeγfgh") # 非ASCII文字を除外
"abcdefgh"

julia> replace("abcdeγfgh", !isascii=>' ') # 非ASCII文字をスペースに置き換え
"abcde fgh"
```
