```julia
_hl_annotations!(highlights::Vector{@NamedTuple{region::UnitRange{Int}, label::Symbol, value::Any}},
                 lineage::GreenLineage, ctx::HighlightContext)
```

Populate `highlights` with annotations for the given `lineage` and `ctx`, where `lineage` is expected to be consistent with `ctx.offset` and `ctx.lnode`.
