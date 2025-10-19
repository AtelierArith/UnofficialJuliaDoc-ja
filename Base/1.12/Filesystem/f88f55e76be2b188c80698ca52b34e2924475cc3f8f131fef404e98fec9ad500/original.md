```julia
uperm(path)
uperm(path_elements...)
uperm(stat_struct)
```

Return a bitfield of the owner permissions for the file at `path` or file descriptor `stat_struct`.

| Value | Description        |
|:----- |:------------------ |
| 01    | Execute Permission |
| 02    | Write Permission   |
| 04    | Read Permission    |

The fact that a bitfield is returned means that if the permission is read+write, the bitfield is "110", which maps to the decimal value of 0+2+4=6. This is reflected in the printing of the returned `UInt8` value.

See also [`gperm`](@ref) and [`operm`](@ref).

```jldoctest
julia> touch("dummy_file");  # Create test-file without contents

julia> uperm("dummy_file")
0x06

julia> bitstring(ans)
"00000110"

julia> has_read_permission(path) = uperm(path) & 0b00000100 != 0;  # Use bit mask to check specific bit

julia> has_read_permission("dummy_file")
true

julia> rm("dummy_file")     # Clean up test-file
```
