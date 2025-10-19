```julia
escape_raw_string(s::AbstractString, delim='"') -> AbstractString
escape_raw_string(io, s::AbstractString, delim='"')
```

Escape a string in the manner used for parsing raw string literals. For each double-quote (`"`) character in input string `s` (or `delim` if specified), this function counts the number *n* of preceding backslash (`\`) characters, and then increases there the number of backslashes from *n* to 2*n*+1 (even for *n* = 0). It also doubles a sequence of backslashes at the end of the string.

This escaping convention is used in raw strings and other non-standard string literals. (It also happens to be the escaping convention expected by the Microsoft C/C++ compiler runtime when it parses a command-line string into the argv[] array.)

See also [`Base.escape_string()`](@ref).
