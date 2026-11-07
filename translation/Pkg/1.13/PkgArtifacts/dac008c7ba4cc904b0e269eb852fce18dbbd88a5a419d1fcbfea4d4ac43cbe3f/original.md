```julia
archive_artifact(hash::SHA1, tarball_path::String; honor_overrides::Bool=false)
```

Archive an artifact into a tarball stored at `tarball_path`, returns the SHA256 of the resultant tarball as a hexadecimal string. Throws an error if the artifact does not exist.  If the artifact is overridden, throws an error unless `honor_overrides` is set.
