```julia
emit(stream, mark, kind, flags = EMPTY_FLAGS; error=nothing)
```

Emit a new non-terminal node into the output which covers source bytes from `mark` to the end of the most recent token which was `bump()`'ed. The starting `mark` should be a previous return value of `position()`. The emitted node will have its `node_span` set to the number of nodes emitted since `mark`.
