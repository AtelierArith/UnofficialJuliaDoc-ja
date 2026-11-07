```julia
face!(str::Union{<:AnnotatedString, <:SubString{<:AnnotatedString}},
      [range::UnitRange{Int},] face::Union{Symbol, Face})
```

`str`に`face`を適用します。指定されている場合は`range`に、指定されていない場合は`str`全体に適用します。
