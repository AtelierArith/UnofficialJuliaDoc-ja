```
annotations(str::Union{AnnotatedString, SubString{AnnotatedString}},
            [position::Union{Integer, UnitRange}]) ->
    Vector{@NamedTuple{region::UnitRange{Int64}, label::Symbol, value}}
```

Get all annotations that apply to `str`. Should `position` be provided, only annotations that overlap with `position` will be returned.

Annotations are provided together with the regions they apply to, in the form of a vector of region–annotation tuples.

In accordance with the semantics documented in [`AnnotatedString`](@ref), the order of annotations returned matches the order in which they were applied.

See also: [`annotate!`](@ref).
