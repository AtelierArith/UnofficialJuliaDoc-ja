```
lazy"str"
```

Create a [`LazyString`](@ref) using regular string interpolation syntax. Note that interpolations are *evaluated* at LazyString construction time, but *printing* is delayed until the first access to the string.

See [`LazyString`](@ref) documentation for the safety properties for concurrent programs.

# Examples

```
julia> n = 5; str = lazy"n is $n"
"n is 5"

julia> typeof(str)
LazyString
```

!!! compat "Julia 1.8"
    `lazy"str"` requires Julia 1.8 or later.

