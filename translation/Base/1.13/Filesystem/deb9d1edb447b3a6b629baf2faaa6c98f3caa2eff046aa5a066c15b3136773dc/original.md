```julia
prepare_for_deletion(path::AbstractString)
```

Prepares the given `path` for deletion by ensuring that all directories within that `path` have write permissions, so that files can be removed from them.  This is automatically invoked by methods such as `mktempdir()` to ensure that no matter what weird permissions a user may have created directories with within the temporary prefix, it will always be deleted.
