```
isvalid(value) -> Bool
```

与えられた値がその型に対して有効であれば `true` を返します。現在、有効な型は `AbstractChar` または `String` または `SubString{String}` のいずれかです。

# 例

```jldoctest
julia> isvalid(Char(0xd800))
false

julia> isvalid(SubString(String(UInt8[0xfe,0x80,0x80,0x80,0x80,0x80]),1,2))
false

julia> isvalid(Char(0xd799))
true
```
