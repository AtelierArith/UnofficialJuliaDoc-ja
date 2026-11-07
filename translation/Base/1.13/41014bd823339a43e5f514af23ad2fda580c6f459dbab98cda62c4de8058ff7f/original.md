```julia
_clear_annotations_in_region!(annotations::Vector{@NamedTuple{region::UnitRange{Int64}, label::Symbol, value}}, span::UnitRange{Int})
```

Erase the presence of `annotations` within a certain `span`.

This operates by removing all elements of `annotations` that are entirely contained in `span`, truncating ranges that partially overlap, and splitting annotations that subsume `span` to just exist either side of `span`.
