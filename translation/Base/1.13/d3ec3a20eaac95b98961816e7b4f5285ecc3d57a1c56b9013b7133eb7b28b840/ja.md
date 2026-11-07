```julia
reinterpret(::Type{Out}, x::In)
```

isbits値`x`内のバイナリデータの型解釈を、isbits型`Out`として解釈されるように変更します。`Out`のサイズ（パディングを除く）は、`x`の型のサイズと同じでなければなりません。たとえば、`reinterpret(Float32, UInt32(7))`は、`UInt32(7)`に対応する4バイトを[`Float32`](@ref)として解釈します。なお、`reinterpret(In, reinterpret(Out, x)) === x`

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
    パディングの扱いは、reinterpret(::DataType, ::AbstractArray)の場合とは異なります。


!!! warning
    `Out`内のビットの組み合わせの一部が有効とみなされず、本来なら型のコンストラクターやメソッドによって排除される場合は、注意してください。追加の検証を行わないと、予期しない動作が発生する可能性があります。

