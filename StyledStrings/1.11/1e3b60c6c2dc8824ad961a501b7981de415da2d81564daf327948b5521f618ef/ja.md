```
face!(str::Union{<:AnnotatedString, <:SubString{<:AnnotatedString}},
      [range::UnitRange{Int},] face::Union{Symbol, Face})
```

`face`を`str`に適用します。指定された場合は`range`に沿って、または`str`全体に適用します。
