```julia
localindices(S::SharedArray)
```

Return a range describing the "default" indices to be handled by the current process.  This range should be interpreted in the sense of linear indexing, i.e., as a sub-range of `1:length(S)`.  In multi-process contexts, returns an empty range in the parent process (or any process for which [`indexpids`](@ref) returns 0).

It's worth emphasizing that `localindices` exists purely as a convenience, and you can partition work on the array among workers any way you wish. For a `SharedArray`, all indices should be equally fast for each worker process.
