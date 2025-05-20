```
current(rb::GitRebase) -> Csize_t
```

Return the index of the current [`RebaseOperation`](@ref). If no operation has yet been applied (because the [`GitRebase`](@ref) has been constructed but `next` has not yet been called or iteration over `rb` has not yet begun), return `GIT_REBASE_NO_OPERATION`, which is equal to `typemax(Csize_t)`.
