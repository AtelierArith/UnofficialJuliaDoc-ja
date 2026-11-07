```julia
committer(c::GitCommit)
```

Return the `Signature` of the committer of the commit `c`. The committer is the person who committed the changes originally authored by the [`author`](@ref), but need not be the same as the `author`, for example, if the `author` emailed a patch to a `committer` who committed it.
