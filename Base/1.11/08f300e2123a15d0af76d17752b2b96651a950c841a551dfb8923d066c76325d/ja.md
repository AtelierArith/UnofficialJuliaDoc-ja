```
codeunit(s::AbstractString) -> Type{<:Union{UInt8, UInt16, UInt32}}
```

与えられた文字列オブジェクトのコードユニットタイプを返します。ASCII、Latin-1、またはUTF-8エンコードされた文字列の場合、これは`UInt8`になります。UCS-2およびUTF-16の場合は`UInt16`、UTF-32の場合は`UInt32`になります。コードユニットタイプはこれらの3つのタイプに限定される必要はありませんが、これらのユニットのいずれかを使用しない広く使用されている文字列エンコーディングを考えるのは難しいです。`codeunit(s)`は、`s`が空でない文字列の場合、`typeof(codeunit(s,1))`と同じです。

詳細は[`ncodeunits`](@ref)を参照してください。
