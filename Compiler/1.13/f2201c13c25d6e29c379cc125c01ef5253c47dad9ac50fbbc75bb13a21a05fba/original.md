```julia
argextype(x, src::Union{IRCode,IncrementalCompact}) -> t
argextype(x, src::CodeInfo, sptypes::Vector{VarState}) -> t
```

Return the type of value `x` in the context of inferred source `src`. Note that `t` might be an extended lattice element. Use `widenconst(t)` to get the native Julia type of `x`.
