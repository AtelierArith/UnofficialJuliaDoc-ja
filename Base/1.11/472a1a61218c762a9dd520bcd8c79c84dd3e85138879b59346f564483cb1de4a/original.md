```
require(into::Module, module::Symbol)
```

This function is part of the implementation of [`using`](@ref) / [`import`](@ref), if a module is not already defined in `Main`. It can also be called directly to force reloading a module, regardless of whether it has been loaded before (for example, when interactively developing libraries).

Loads a source file, in the context of the `Main` module, on every active node, searching standard locations for files. `require` is considered a top-level operation, so it sets the current `include` path but does not use it to search for files (see help for [`include`](@ref)). This function is typically used to load library code, and is implicitly called by `using` to load packages.

When searching for files, `require` first looks for package code in the global array [`LOAD_PATH`](@ref). `require` is case-sensitive on all platforms, including those with case-insensitive filesystems like macOS and Windows.

For more details regarding code loading, see the manual sections on [modules](@ref modules) and [parallel computing](@ref code-availability).
