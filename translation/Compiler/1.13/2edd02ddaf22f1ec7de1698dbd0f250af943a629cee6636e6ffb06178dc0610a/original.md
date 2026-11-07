```julia
stmts_awaiting_insertion(compact::IncrementalCompact, idx::Int)
```

Returns true if there are new/pending instructions enqueued for insertion into `compact` on any instruction in the range `1:idx`. Otherwise, returns false.
