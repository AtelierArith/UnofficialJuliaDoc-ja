```julia
codeunit(s::AbstractString, i::Integer)::Union{UInt8, UInt16, UInt32}
```

文字列 `s` のインデックス `i` にあるコード単位の値を返します。なお、

```julia
codeunit(s, i) :: codeunit(s)
```

つまり、`codeunit(s, i)` が返す値の型は、`codeunit(s)` が返す型です。

# Examples

```jldoctest
julia> a = codeunit("Hello", 2)
0x65

julia> typeof(a)
UInt8
```

[`ncodeunits`](@ref)、[`checkbounds`](@ref) も参照してください。
