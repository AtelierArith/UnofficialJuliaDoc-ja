```julia
codeunits(s::AbstractString)
```

文字列のコードユニットを含むベクトルのようなオブジェクトを取得します。デフォルトでは `CodeUnits` ラッパーを返しますが、必要に応じて新しい文字列型のために `codeunits` を定義することもできます。

# 例

```jldoctest
julia> codeunits("Juλia")
6-element Base.CodeUnits{UInt8, String}:
 0x4a
 0x75
 0xce
 0xbb
 0x69
 0x61
```
