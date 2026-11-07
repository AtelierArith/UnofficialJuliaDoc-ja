```julia
info::UnionSplitInfo <: CallInfo
```

If inference decides to partition the method search space by splitting unions, it will issue a method lookup query for each such partition. This info indicates that such partitioning happened and wraps the corresponding `MethodMatchInfo` for each partition (`info.matches::Vector{MethodMatchInfo}`). This info is illegal on any statement that is not a call to a generic function.
