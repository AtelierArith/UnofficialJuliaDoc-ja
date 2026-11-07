```julia
peek(stream[, T=UInt8])
```

ストリームの現在位置を進めずに、ストリームから値を読み取り、型 `T` の値を返します。詳細は [`startswith(stream, char_or_string)`](@ref) も参照してください。

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
    型を受け取るメソッドは、Julia 1.5 以降で利用できます。

