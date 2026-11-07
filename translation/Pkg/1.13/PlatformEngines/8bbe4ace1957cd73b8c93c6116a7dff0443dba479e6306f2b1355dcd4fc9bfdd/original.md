```julia
verify(path::AbstractString, hash::AbstractString;
       verbose::Bool = false, report_cache_status::Bool = false,
       details::Union{Vector{String},Nothing} = nothing)
```

Given a file `path` and a `hash`, calculate the SHA256 of the file and compare it to `hash`.  This method caches verification results in a `"$(path).sha256"` file to accelerate reverification of files that have been previously verified. If no `".sha256"` file exists, a full verification will be done and the file will be created, with the calculated hash being stored within the `".sha256"` file.  If a `".sha256"` file does exist, its contents are checked to ensure that the hash contained within matches the given `hash` parameter, and its modification time shows that the file located at `path` has not been modified since the last verification.

If `report_cache_status` is set to `true`, then the return value will be a `Symbol` giving a granular status report on the state of the hash cache, in addition to the `true`/`false` signifying whether verification completed successfully.

If `details` is provided, any pertinent detail will be pushed to it rather than logged.
