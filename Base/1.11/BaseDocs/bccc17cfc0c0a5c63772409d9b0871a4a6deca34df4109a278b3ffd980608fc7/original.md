```
Symbol(x...) -> Symbol
```

Create a [`Symbol`](@ref) by concatenating the string representations of the arguments together.

# Examples

```jldoctest
julia> Symbol("my", "name")
:myname

julia> Symbol("day", 4)
:day4
```
