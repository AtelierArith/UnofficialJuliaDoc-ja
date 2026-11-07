```julia
MissingOptimization(next) isa Base.Sort.Algorithm
```

Filter out missing values.

Missing values are placed after other values according to `DirectOrdering`s. This pass puts them there and passes on a view into the original vector that excludes the missing values. This pass is triggered for both `sort([1, missing, 3])` and `sortperm([1, missing, 3])`.
