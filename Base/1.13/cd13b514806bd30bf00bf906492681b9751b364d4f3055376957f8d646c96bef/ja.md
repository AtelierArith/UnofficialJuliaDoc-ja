```julia
peek(stream[, T=UInt8])
```

ストリームの現在位置を進めずに、ストリームから値を読み取り、型 `T` の値として返します。関連項目: [`startswith(stream, char_or_string)`](@ref)。

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

