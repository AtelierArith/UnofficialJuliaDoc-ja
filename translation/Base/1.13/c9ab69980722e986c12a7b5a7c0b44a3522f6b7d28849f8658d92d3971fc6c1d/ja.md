```julia
codeunit(s::AbstractString)::Type{<:Union{UInt8, UInt16, UInt32}}
```

指定された文字列オブジェクトのコード単位型を返します。ASCII、Latin-1、UTF-8でエンコードされた文字列の場合は`UInt8`、UCS-2およびUTF-16の場合は`UInt16`、UTF-32の場合は`UInt32`です。コード単位型はこの3種類に限られませんが、これらのいずれの単位も使わない、広く使われている文字列エンコーディングを思い浮かべるのは困難です。`codeunit(s)`は、`s`が空でない文字列の場合、`typeof(codeunit(s,1))`と同じです。

関連項目：[`ncodeunits`](@ref)。
