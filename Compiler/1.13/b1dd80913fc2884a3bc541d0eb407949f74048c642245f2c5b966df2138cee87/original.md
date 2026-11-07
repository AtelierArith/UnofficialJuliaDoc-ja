```julia
walk_to_defs(compact, val, typeconstraint, predecessors)
```

Starting at `val` walk use-def chains to get all the leaves feeding into this `val` (pruning those leaves ruled out by path conditions).

`predecessors(def, compact)` is a callback which should return the set of possible predecessors for a "phi-like" node (PhiNode or Core.ifelse) or `nothing` otherwise.
