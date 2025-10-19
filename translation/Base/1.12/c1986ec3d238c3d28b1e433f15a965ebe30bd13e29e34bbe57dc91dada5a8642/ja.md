```julia
annotate!(str::AnnotatedString, [range::UnitRange{Int}], label::Symbol, value)
annotate!(str::SubString{AnnotatedString}, [range::UnitRange{Int}], label::Symbol, value)
```

`str`の`range`（または全体の文字列）にラベル付きの値`(label, value)`で注釈を付けます。既存の`label`注釈を削除するには、`nothing`の値を使用します。

`str`に注釈が適用される順序は意味的に重要であり、[`AnnotatedString`](@ref)で説明されています。
