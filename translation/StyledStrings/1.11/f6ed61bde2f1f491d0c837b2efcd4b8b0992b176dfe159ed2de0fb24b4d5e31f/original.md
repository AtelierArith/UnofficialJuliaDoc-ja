```julia
parse(::Type{SimpleColor}, rgb::String)
```

An analogue of `tryparse(SimpleColor, rgb::String)` (which see), that raises an error instead of returning `nothing`.
