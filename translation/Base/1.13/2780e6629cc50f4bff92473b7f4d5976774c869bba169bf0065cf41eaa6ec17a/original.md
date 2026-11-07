```julia
format_bytes(bytes; binary=true)
```

Format a given number of bytes into a human-readable string.

# Arguments

  * `bytes`: The number of bytes to format.
  * `binary=true`: If `true`, formats the bytes in binary units (powers of 1024). If `false`, uses decimal units (powers of 1000).

# Returns

`String`: A human-readable string representation of the bytes, formatted in either binary or decimal units based on the `binary` argument.

# Examples

```jldoctest
julia> Base.format_bytes(1024)
"1024 bytes"

julia> Base.format_bytes(10000)
"9.766 KiB"

julia> Base.format_bytes(10000, binary=false)
"10.000 kB"
```
