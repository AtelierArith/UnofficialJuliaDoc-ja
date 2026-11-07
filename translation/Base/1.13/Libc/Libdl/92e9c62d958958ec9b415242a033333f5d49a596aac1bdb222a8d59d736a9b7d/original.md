```julia
LazyLibrary(name; flags = <default dlopen flags>,
            dependencies = LazyLibrary[], on_load_callback = nothing)
```

Represents a lazily-loaded shared library that delays loading itself and its dependencies until first use in a `ccall()`, `@ccall`, `dlopen()`, `dlsym()`, `dlpath()`, or `cglobal()`. This is a thread-safe mechanism for on-demand library initialization.

# Arguments

  * `name`: Library name (or lazy path computation) as a `String`, [`LazyLibraryPath`](@ref), or [`BundledLazyLibraryPath`](@ref).
  * `flags`: Optional `dlopen` flags (default: `RTLD_LAZY | RTLD_DEEPBIND`). See [`dlopen`](@ref).
  * `dependencies`: Vector of `LazyLibrary` object references to load before this one.
  * `on_load_callback`: Optional function to run arbitrary code on first load (use sparingly, as it is not expected that `ccall()` should result in large amounts of Julia code being run. You may call `ccall()` from within the `on_load_callback` but only for the current library and its dependencies, and user should not call `wait()` on any tasks within the on load callback as they may deadlock).

The dlopen operation is thread-safe: only one thread loads the library, acquired after the release store of the reference to each dependency from loading of each dependency. Other tasks block until loading completes. The handle is then cached and reused for all subsequent calls (there is no dlclose for lazy library and dlclose should not be called on the returned handled).

# Examples

```julia
# Basic usage
const mylib = LazyLibrary("libmylib")
@ccall mylib.myfunc(42::Cint)::Cint

# With dependencies
const libfoo = LazyLibrary("libfoo")
const libbar = LazyLibrary("libbar"; dependencies=[libfoo])
```

For more examples including platform-specific libraries, lazy path construction, and migration from `__init__()` patterns, see the manual section on [Using LazyLibrary for Lazy Loading](@ref man-lazylibrary).

!!! compat "Julia 1.11"
    `LazyLibrary` was added in Julia 1.11.


See also [`LazyLibraryPath`](@ref), [`BundledLazyLibraryPath`](@ref), [`dlopen`](@ref), [`dlsym`](@ref), [`add_dependency!`](@ref).
