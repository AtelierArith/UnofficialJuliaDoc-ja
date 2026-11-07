```julia
LogicalIndex(mask)
```

The `LogicalIndex` type is a special vector that simply contains all indices I where `mask[I]` is true. This specialized type does not support indexing directly as doing so would require O(n) lookup time. `AbstractArray{Bool}` are wrapped with `LogicalIndex` upon calling [`to_indices`](@ref).
