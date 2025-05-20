```
reinterpret(::Type{Out}, x::In)
```

Change the type-interpretation of the binary data in the isbits value `x` to that of the isbits type `Out`. The size (ignoring padding) of `Out` has to be the same as that of the type of `x`. For example, `reinterpret(Float32, UInt32(7))` interprets the 4 bytes corresponding to `UInt32(7)` as a [`Float32`](@ref). Note that `reinterpret(In, reinterpret(Out, x)) === x`

```jldoctest
julia> reinterpret(Float32, UInt32(7))
1.0f-44

julia> reinterpret(NTuple{2, UInt8}, 0x1234)
(0x34, 0x12)

julia> reinterpret(UInt16, (0x34, 0x12))
0x1234

julia> reinterpret(Tuple{UInt16, UInt8}, (0x01, 0x0203))
(0x0301, 0x02)
```

!!! note
    The treatment of padding differs from reinterpret(::DataType, ::AbstractArray).


!!! warning
    Use caution if some combinations of bits in `Out` are not considered valid and would otherwise be prevented by the type's constructors and methods. Unexpected behavior may result without additional validation.

