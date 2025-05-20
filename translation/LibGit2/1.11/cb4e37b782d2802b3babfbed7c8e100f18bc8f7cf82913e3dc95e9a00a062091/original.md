```
read!(idx::GitIndex, force::Bool = false) -> GitIndex
```

Update the contents of `idx` by reading changes made on disk. For example, `idx` might be updated if a file has been added to the repository since it was created. If `force` is `true`, any changes in memory (any changes in `idx` since its last [`write!`](@ref), or since its creation if no writes have occurred) are discarded. If `force` is `false`, the index data is only updated from disk if the data on disk has changed since the last time it was loaded into `idx`.
