```julia
download_verify_unpack(
    url::AbstractString,
    hash::Union{AbstractString, Nothing},
    dest::AbstractString;
    tarball_path = nothing,
    ignore_existence::Bool = false,
    force::Bool = false,
    verbose::Bool = false,
    quiet_download::Bool = false,
    io::IO=stderr,
)
```

Helper method to download tarball located at `url`, verify it matches the given `hash`, then unpack it into folder `dest`.  In general, the method `install()` should be used to download and install tarballs into a `Prefix`; this method should only be used if the extra functionality of `install()` is undesired.

If `tarball_path` is specified, the given `url` will be downloaded to `tarball_path`, and it will not be removed after downloading and verification is complete.  If it is not specified, the tarball will be downloaded to a temporary location, and removed after verification is complete.

If `force` is specified, a verification failure will cause `tarball_path` to be deleted (if it exists), the `dest` folder to be removed (if it exists) and the tarball to be redownloaded and reverified.  If the verification check is failed a second time, an exception is raised.  If `force` is not specified, a verification failure will result in an immediate raised exception.

If `ignore_existence` is set, the tarball is unpacked even if the destination directory already exists.

Returns `true` if a tarball was actually unpacked, `false` if nothing was changed in the destination prefix.
