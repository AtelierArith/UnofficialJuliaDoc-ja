```julia
kill_edge_terminator!(compact::IncrementalCompact, active_bb::Int, from::Int, to::Int)
```

Kill a CFG edge while compacting a terminator in `active_bb`. Assumes all PhiNode block statements in `to` have already been processed, so the active BB may only scan the compacted prefix when `to == active_bb`. `from` and `to` are non-renamed indices.
