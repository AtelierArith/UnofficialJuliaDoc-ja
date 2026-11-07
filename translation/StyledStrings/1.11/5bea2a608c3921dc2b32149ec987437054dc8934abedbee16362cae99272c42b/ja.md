```julia
face!(str::Union{<:AnnotatedString, <:SubString{<:AnnotatedString}},
      [range::UnitRange{Int},] face::Union{Symbol, Face})
```

`face`を、指定されている場合は`range`に沿って`str`に適用するか、`str`全体に適用します。
