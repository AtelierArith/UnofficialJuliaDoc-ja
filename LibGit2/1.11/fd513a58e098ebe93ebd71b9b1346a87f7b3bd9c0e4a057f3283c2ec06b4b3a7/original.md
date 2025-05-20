```
files_changed(diff_stat::GitDiffStats) -> Csize_t
```

Return how many files were changed (added/modified/deleted) in the [`GitDiff`](@ref) summarized by `diff_stat`. The result may vary depending on the [`DiffOptionsStruct`](@ref) used to generate the parent `GitDiff` of `diff_stat` (for instance, whether ignored files are to be included or not).
