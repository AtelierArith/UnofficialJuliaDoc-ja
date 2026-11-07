```julia
isvalid(value)::Bool
```

指定された値がその型として有効な場合は、`true`を返します。現在、型は`AbstractChar`、`String`、または`SubString{String}`のいずれかです。

# Examples

```jldoctest
julia> isvalid(Char(0xd800))
false

julia> isvalid(SubString(String(UInt8[0xfe,0x80,0x80,0x80,0x80,0x80]),1,2))
false

julia> isvalid(Char(0xd799))
true
```
