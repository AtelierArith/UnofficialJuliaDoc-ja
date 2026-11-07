```julia
compute_frameinfo(ir::IRCode) -> tryregions
```

A preparatory linear scan before the escape analysis on `ir` to find `tryregions::Union{Nothing,Vector{UnitRange{Int}}}`, that represent regions in which potential `throw`s can be caught (used by `escape_exception!`)
