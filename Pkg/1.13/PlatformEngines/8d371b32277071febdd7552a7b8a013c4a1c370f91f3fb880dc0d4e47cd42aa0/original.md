```julia
download_verify(
    url::AbstractString,
    hash::Union{AbstractString, Nothing},
    dest::AbstractString;
    verbose::Bool = false,
    force::Bool = false,
    quiet_download::Bool = false,
)
```

Download file located at `url`, verify it matches the given `hash`, and throw an error if anything goes wrong.  If `dest` already exists, just verify it. If `force` is set to `true`, overwrite the given file if it exists but does not match the given `hash`.

This method returns `true` if the file was downloaded successfully, `false` if an existing file was removed due to the use of `force`, and throws an error if `force` is not set and the already-existent file fails verification, or if `force` is set, verification fails, and then verification fails again after redownloading the file.

If `quiet_download` is set to `false`, this method will print to stdout when downloading a new file.  If it is set to `true` (default, and `verbose` is set to `false`) the downloading process will be completely silent.  If `verbose` is set to `true`, messages about integrity verification will be printed in addition to messages regarding downloading.
