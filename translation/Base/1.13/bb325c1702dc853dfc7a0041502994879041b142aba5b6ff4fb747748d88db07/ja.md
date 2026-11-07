```julia
isascii(c::Union{AbstractChar,AbstractString})::Bool
```

文字がASCII文字セットに属するかどうか、または文字列のすべての要素がASCII文字セットに属するかどうかを判定します。

# Examples

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

たとえば、`isascii`は、非ASCII文字を削除または置換するための述語関数として、[`filter`](@ref)または[`replace`](@ref)にそれぞれ渡せます。

```jldoctest
julia> filter(isascii, "abcdeγfgh") # discard non-ASCII chars
"abcdefgh"

julia> replace("abcdeγfgh", !isascii=>' ') # replace non-ASCII chars with spaces
"abcde fgh"
```
