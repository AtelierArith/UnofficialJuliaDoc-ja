```julia
_insert_annotations!(io::AnnotatedIOBuffer, annotations::Vector{@NamedTuple{region::UnitRange{Int64}, label::Symbol, value}}, offset::Int = position(io))
```

Register new `annotations` in `io`, applying an `offset` to their regions.

The largely consists of simply shifting the regions of `annotations` by `offset` and pushing them onto `io`'s annotations. However, when it is possible to merge the new annotations with recent annotations in accordance with the semantics outlined in [`AnnotatedString`](@ref), we do so. More specifically, when there is a run of the most recent annotations that are also present as the first `annotations`, with the same value and adjacent regions, the new annotations are merged into the existing recent annotations by simply extending their range.

This is implemented so that one can say write an `AnnotatedString` to an `AnnotatedIOBuffer` one character at a time without needlessly producing a new annotation for each character.
