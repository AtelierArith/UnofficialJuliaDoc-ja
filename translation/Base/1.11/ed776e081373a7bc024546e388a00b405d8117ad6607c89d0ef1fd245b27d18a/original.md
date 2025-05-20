```
peek(stream[, T=UInt8])
```

Read and return a value of type `T` from a stream without advancing the current position in the stream.   See also [`startswith(stream, char_or_string)`](@ref).

# Examples

```jldoctest
julia> b = IOBuffer("julia");

julia> peek(b)
0x6a

julia> position(b)
0

julia> peek(b, Char)
'j': ASCII/Unicode U+006A (category Ll: Letter, lowercase)
```

!!! compat "Julia 1.5"
    The method which accepts a type requires Julia 1.5 or later.

