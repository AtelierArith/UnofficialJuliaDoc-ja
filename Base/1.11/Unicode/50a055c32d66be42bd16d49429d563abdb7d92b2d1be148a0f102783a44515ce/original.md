```
isvalid(value) -> Bool
```

Return `true` if the given value is valid for its type, which currently can be either `AbstractChar` or `String` or `SubString{String}`.

# Examples

```jldoctest
julia> isvalid(Char(0xd800))
false

julia> isvalid(SubString(String(UInt8[0xfe,0x80,0x80,0x80,0x80,0x80]),1,2))
false

julia> isvalid(Char(0xd799))
true
```
