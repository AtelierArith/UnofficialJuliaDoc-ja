```julia
annotate!(str::AnnotatedString, [range::UnitRange{Int}], label::Symbol, value)
annotate!(str::SubString{AnnotatedString}, [range::UnitRange{Int}], label::Symbol, value)
```

`str`（または文字列全体）に、ラベル付きの値 `(label, value)` を付けて、`range` に注釈を付けます。既存の `label` 注釈を削除するには、`nothing` の値を指定します。

`str` に注釈を適用する順序は意味を持ちます。詳しくは [`AnnotatedString`](@ref) を参照してください。
