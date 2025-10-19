```julia
annotatedstring(values...)
```

Create a `AnnotatedString` from any number of `values` using their [`print`](@ref)ed representation.

This acts like [`string`](@ref), but takes care to preserve any annotations present (in the form of [`AnnotatedString`](@ref) or [`AnnotatedChar`](@ref) values).

See also [`AnnotatedString`](@ref) and [`AnnotatedChar`](@ref).

## Examples

```jldoctest; setup=:(using Base: AnnotatedString, annotatedstring)
julia> annotatedstring("now a AnnotatedString")
"now a AnnotatedString"

julia> annotatedstring(AnnotatedString("annotated", [(1:9, :label, 1)]), ", and unannotated")
"annotated, and unannotated"
```
