```julia
_terminfo_read_strings(table::Vector{UInt8}, indices::Vector{Int16})
```

From `table`, read a string starting at each position in `indices`. Each string must be null-terminated. Should an index be -1 or -2, `nothing` is given instead of a string.
