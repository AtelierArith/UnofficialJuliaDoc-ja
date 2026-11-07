```julia
sroa_pass!(ir::IRCode) -> newir::IRCode
```

`getfield` elimination pass, a.k.a. Scalar Replacements of Aggregates optimization.

This pass is based on a local field analysis by def-use chain walking. It looks for struct allocation sites ("definitions"), and `getfield` calls as well as `:foreigncall`s that preserve the structs ("usages"). If "definitions" have enough information, then this pass will replace corresponding usages with forwarded values. `mutable struct`s require additional cares and need to be handled separately from immutables. For `mutable struct`s, `setfield!` calls account for "definitions" also, and the pass should give up the lifting conservatively when there are any "intermediate usages" that may escape the mutable struct (e.g. non-inlined generic function call that takes the mutable struct as its argument).

In a case when all usages are fully eliminated, `struct` allocation may also be erased as a result of succeeding dead code elimination.
