```julia
reinterpret(::Type{Out}, x::In)
```

isbits値`x`のバイナリデータの型解釈をisbits型`Out`のものに変更します。`Out`のサイズ（パディングを無視）は、`x`の型のサイズと同じでなければなりません。例えば、`reinterpret(Float32, UInt32(7))`は、`UInt32(7)`に対応する4バイトを[`Float32`](@ref)として解釈します。`reinterpret(In, reinterpret(Out, x)) === x`であることに注意してください。

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
    パディングの扱いは、reinterpret(::DataType, ::AbstractArray)とは異なります。


!!! warning
    `Out`のビットのいくつかの組み合わせが無効と見なされ、型のコンストラクタやメソッドによって防止される場合は注意してください。追加の検証なしに予期しない動作が発生する可能性があります。

