```julia
tryparse(::Type{SimpleColor}, rgb::String)
```

`rgb`を`SimpleColor`として解析しようとします。`rgb`が`#`で始まり、長さが7の場合、`RGBTuple`に基づく`SimpleColor`に変換されます。`rgb`が`a`-`z`で始まる場合、`rgb`は色名として解釈され、`Symbol`に基づく`SimpleColor`に変換されます。

それ以外の場合は、`nothing`が返されます。

# 例

```jldoctest; setup = :(import StyledStrings.SimpleColor)
julia> tryparse(SimpleColor, "blue")
SimpleColor(blue)

julia> tryparse(SimpleColor, "#9558b2")
SimpleColor(#9558b2)

julia> tryparse(SimpleColor, "#nocolor")
```
