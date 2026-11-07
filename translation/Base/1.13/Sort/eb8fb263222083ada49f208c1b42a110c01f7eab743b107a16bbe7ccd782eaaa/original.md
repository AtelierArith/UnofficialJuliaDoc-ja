```julia
BoolOptimization(next) isa Base.Sort.Algorithm
```

Sort `AbstractVector{Bool}`s using a specialized version of counting sort.

Accesses each element at most twice (one read and one write), and performs at most two comparisons.
