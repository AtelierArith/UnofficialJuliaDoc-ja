```julia
codeunits(s::AbstractString)
```

文字列のコード単位を含む、ベクターに似たオブジェクトを取得します。デフォルトでは `CodeUnits` ラッパーを返しますが、必要に応じて、新しい文字列型に対して `codeunits` を定義することもできます。

# Examples

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
