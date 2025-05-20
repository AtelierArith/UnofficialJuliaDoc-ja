```
sizeof(str::AbstractString)
```

Size, in bytes, of the string `str`. Equal to the number of code units in `str` multiplied by the size, in bytes, of one code unit in `str`.

# Examples

```jldoctest
julia> sizeof("")
0

julia> sizeof("∀")
3
```
