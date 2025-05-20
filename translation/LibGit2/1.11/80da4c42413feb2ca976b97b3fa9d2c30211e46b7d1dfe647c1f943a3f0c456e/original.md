```
finish(rb::GitRebase, sig::GitSignature) -> Csize_t
```

Complete the rebase described by `rb`. `sig` is a [`GitSignature`](@ref) to specify the identity of the user finishing the rebase. Return `0` if the rebase finishes successfully, `-1` if there is an error.
