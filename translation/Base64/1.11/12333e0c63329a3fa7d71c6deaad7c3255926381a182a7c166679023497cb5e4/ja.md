```julia
base64decode(string)
```

base64でエンコードされた`string`をデコードし、デコードされたバイト列の`Vector{UInt8}`を返します。

[`base64encode`](@ref)も参照してください。

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
