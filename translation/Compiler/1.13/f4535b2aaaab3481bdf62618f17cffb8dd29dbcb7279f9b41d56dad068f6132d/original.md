```julia
struct NewSSAValue
```

`NewSSAValue`s occur in the context of IncrementalCompact. Their meaning depends on where they appear:

1. In already-compacted nodes,  i. a `NewSSAValue` with positive `id` has the same meaning as a regular SSAValue.  ii. a `NewSSAValue` with negative `id` refers to post-compaction `new_node` node.
2. In non-compacted nodes,  i. a `NewSSAValue` with positive `id` refers to the index of an already-compacted instructions.  ii. a `NewSSAValue` with negative `id` has the same meaning as in compacted nodes.
