```julia
annotate!(str::AnnotatedString, [range::UnitRange{Int}], label::Symbol, value)
annotate!(str::SubString{AnnotatedString}, [range::UnitRange{Int}], label::Symbol, value)
```

`str`の`range`（または文字列全体）に、ラベル付きの値`(label, value)`を付与します。既存の`label`注釈を削除するには、値として`nothing`を指定します。

`str`に注釈を適用する順序には意味があります。詳しくは[`AnnotatedString`](@ref)を参照してください。
