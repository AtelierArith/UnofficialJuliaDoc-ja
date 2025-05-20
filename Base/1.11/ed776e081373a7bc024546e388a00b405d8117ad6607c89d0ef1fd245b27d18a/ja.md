```
peek(stream[, T=UInt8])
```

ストリームから現在の位置を進めることなく、型 `T` の値を読み取って返します。詳細は [`startswith(stream, char_or_string)`](@ref) を参照してください。

# 例

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
    型を受け入れるメソッドは、Julia 1.5 以降が必要です。

