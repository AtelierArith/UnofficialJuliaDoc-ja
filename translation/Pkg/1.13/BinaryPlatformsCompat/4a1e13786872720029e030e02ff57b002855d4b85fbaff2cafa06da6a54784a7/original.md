```julia
valid_dl_path(path::AbstractString, platform::Platform)
```

Return `true` if the given `path` ends in a valid dynamic library filename. E.g. returns `true` for a path like `"usr/lib/libfoo.so.3.5"`, but returns `false` for a path like `"libbar.so.f.a"`.

This method is deprecated and will be removed in Julia 2.0.
