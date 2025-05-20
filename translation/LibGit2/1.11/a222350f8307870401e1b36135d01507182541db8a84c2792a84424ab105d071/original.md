```
write_tree!(idx::GitIndex) -> GitHash
```

Write the index `idx` as a [`GitTree`](@ref) on disk. Trees will be recursively created for each subtree in `idx`. The returned [`GitHash`](@ref) can be used to create a [`GitCommit`](@ref). `idx` must have a parent repository and this repository cannot be bare. `idx` must not contain any files with conflicts.
