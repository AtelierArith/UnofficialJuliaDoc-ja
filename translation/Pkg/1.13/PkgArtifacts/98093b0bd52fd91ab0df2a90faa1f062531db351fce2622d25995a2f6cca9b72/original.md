```julia
download_artifact(tree_hash::SHA1, tarball_url::String, tarball_hash::String;
                    verbose::Bool = false, io::IO=stderr)
```

Download/install an artifact into the artifact store.  Returns `true` on success, returns an error object on failure.

!!! compat "Julia 1.8"
    As of Julia 1.8 this function returns the error object rather than `false` when failure occurs

