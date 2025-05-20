```
entrytype(te::GitTreeEntry)
```

Return the type of the object to which `te` refers. The result will be one of the types which [`objtype`](@ref) returns, e.g. a `GitTree` or `GitBlob`.
