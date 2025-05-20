```
parse_components(str::AbstractString, df::DateFormat) -> Array{Any}
```

文字列を `DateFormat` の指示に従ってそのコンポーネントに解析します。各コンポーネントは異なる型になり、通常は Period のサブタイプです。コンポーネントの順序は `DateFormat` 内の `DatePart` 指示の順序と一致します。コンポーネントの数は、`DatePart` の総数よりも少ない場合があります。
