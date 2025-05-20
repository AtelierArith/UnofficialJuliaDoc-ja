```
base64decode(string)
```

Decode the base64-encoded `string` and returns a `Vector{UInt8}` of the decoded bytes.

See also [`base64encode`](@ref).

# Examples

```jldoctest
julia> b = base64decode("SGVsbG8h")
6-element Vector{UInt8}:
 0x48
 0x65
 0x6c
 0x6c
 0x6f
 0x21

julia> String(b)
"Hello!"
```
