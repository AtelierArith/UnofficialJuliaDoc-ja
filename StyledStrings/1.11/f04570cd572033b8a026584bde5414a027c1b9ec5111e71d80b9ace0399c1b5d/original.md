```
annotation_events(string::AbstractString, annots::Vector{@NamedTuple{region::UnitRange{Int}, label::Symbol, value::Any}}, subregion::UnitRange{Int})
annotation_events(string::AnnotatedString, subregion::UnitRange{Int})
```

Find all annotation "change events" that occur within a `subregion` of `annots`, with respect to `string`. When `string` is styled, `annots` is inferred.

Each change event is given in the form of a `@NamedTuple{pos::Int, active::Bool, index::Int}` where `pos` is the position of the event, `active` is a boolean indicating whether the annotation is being activated or deactivated, and `index` is the index of the annotation in question.
