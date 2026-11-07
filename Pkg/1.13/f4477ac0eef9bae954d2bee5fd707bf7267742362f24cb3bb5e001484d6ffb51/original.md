```julia
is_manifest_current(path::AbstractString)
```

Returns whether the manifest for the project at `path` was resolved from the current project file. For instance, if the project had compat entries changed, but the manifest wasn't re-resolved, this would return false.

If the manifest doesn't have the project hash recorded, or if there is no manifest file, `nothing` is returned.

This function can be used in tests to verify that the manifest is synchronized with the project file:

```julia
using Pkg, Test
@test Pkg.is_manifest_current(pwd())  # Check current project
@test Pkg.is_manifest_current("/path/to/project")  # Check specific project
```
