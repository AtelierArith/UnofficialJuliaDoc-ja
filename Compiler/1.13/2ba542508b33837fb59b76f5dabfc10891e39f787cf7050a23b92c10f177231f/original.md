```julia
ainfo::AbstractIterationInfo
```

Captures all the information for abstract iteration analysis of a single value. Each (abstract) call to `iterate`, corresponds to one entry in `ainfo.each::Vector{CallMeta}`.
