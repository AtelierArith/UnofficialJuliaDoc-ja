```julia
chmod(path::AbstractString, mode::Integer; recursive::Bool=false)
```

Change the permissions mode of `path` to `mode`. Only integer `mode`s (e.g. `0o777`) are currently supported. If `recursive=true` and the path is a directory all permissions in that directory will be recursively changed. Return `path`.

!!! note
    Prior to Julia 1.6, this did not correctly manipulate filesystem ACLs  on Windows, therefore it would only set read-only bits on files.  It  now is able to manipulate ACLs.

