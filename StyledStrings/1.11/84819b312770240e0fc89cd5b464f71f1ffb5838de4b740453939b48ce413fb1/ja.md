```julia
tryparse(::Type{SimpleColor}, rgb::String)
```

`rgb`を`SimpleColor`として解析します。`rgb`が`#`で始まり、長さが7の場合、`RGBTuple`を基盤とする`SimpleColor`に変換されます。`rgb`が`a`-`z`で始まる場合、`rgb`は色名として解釈され、`Symbol`を基盤とする`SimpleColor`に変換されます。

それ以外の場合は、`nothing`が返されます。

# Examples

```jldoctest; setup = :(import StyledStrings.SimpleColor)
julia> tryparse(SimpleColor, "blue")
SimpleColor(blue)

julia> tryparse(SimpleColor, "#9558b2")
SimpleColor(#9558b2)

julia> tryparse(SimpleColor, "#nocolor")
```
