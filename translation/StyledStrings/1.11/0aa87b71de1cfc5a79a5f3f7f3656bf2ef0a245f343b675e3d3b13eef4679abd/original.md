```julia
struct SimpleColor
```

A basic representation of a color, intended for string styling purposes. It can either contain a named color (like `:red`), or an `RGBTuple` which is a NamedTuple specifying an `r`, `g`, `b` color with a bit-depth of 8.

# Constructors

```julia
SimpleColor(name::Symbol)  # e.g. :red
SimpleColor(rgb::RGBTuple) # e.g. (r=1, b=2, g=3)
SimpleColor(r::Integer, b::Integer, b::Integer)
SimpleColor(rgb::UInt32)   # e.g. 0x123456
```

Also see `tryparse(SimpleColor, rgb::String)`.
