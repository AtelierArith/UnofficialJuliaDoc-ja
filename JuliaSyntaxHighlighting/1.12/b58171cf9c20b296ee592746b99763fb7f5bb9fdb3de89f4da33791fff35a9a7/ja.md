```julia
_hl_annotations!(highlights::Vector{@NamedTuple{region::UnitRange{Int}, label::Symbol, value::Any}},
                 lineage::GreenLineage, ctx::HighlightContext)
```

与えられた`lineage`および`ctx`に対する注釈を`highlights`に記入してください。`lineage`は、`ctx.offset`および`ctx.lnode`と整合している必要があります。
