```julia
codeunit(s::AbstractString, i::Integer) -> Union{UInt8, UInt16, UInt32}
```

文字列 `s` のインデックス `i` におけるコードユニット値を返します。注意点として

```julia
codeunit(s, i) :: codeunit(s)
```

すなわち、`codeunit(s, i)` によって返される値は `codeunit(s)` によって返される型です。

# 例

```jldoctest
julia> a = codeunit("Hello", 2)
0x65

julia> typeof(a)
UInt8
```

他にも [`ncodeunits`](@ref), [`checkbounds`](@ref) を参照してください。
