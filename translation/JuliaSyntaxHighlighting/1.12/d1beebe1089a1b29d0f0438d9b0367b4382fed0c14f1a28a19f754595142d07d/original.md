```julia
_hl_annotations(content::AbstractString, ast::GreenNode)
  -> Vector{@NamedTuple{region::UnitRange{Int}, label::Symbol, value::Any}}
```

Generate a list of annotations for the given `content` and `ast`.

Each annotation takes the form of a `@NamedTuple{region::UnitRange{Int}, label::Symbol, value::Any}`, where the region indexes into `content` and the value is a `julia_*` face name.

This is a small wrapper around [`_hl_annotations!`](@ref) for convenience.
