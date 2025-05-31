```
ncodeunits(c::Char) -> Int
```

Return the number of code units required to encode a character as UTF-8. This is the number of bytes which will be printed if the character is written to an output stream, or `ncodeunits(string(c))` but computed efficiently.

!!! compat "Julia 1.1"
    This method requires at least Julia 1.1. In Julia 1.0 consider using `ncodeunits(string(c))`.

