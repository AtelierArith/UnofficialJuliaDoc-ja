```
face!(str::Union{<:AnnotatedString, <:SubString{<:AnnotatedString}},
      [range::UnitRange{Int},] face::Union{Symbol, Face})
```

Apply `face` to `str`, along `range` if specified or the whole of `str`.
