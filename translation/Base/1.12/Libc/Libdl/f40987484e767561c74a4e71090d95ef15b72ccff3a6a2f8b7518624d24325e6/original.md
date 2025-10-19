```julia
LazyLibrary(name, flags = <default dlopen flags>,
            dependencies = LazyLibrary[], on_load_callback = nothing)
```

Represents a lazily-loaded library that opens itself and its dependencies on first usage in a `dlopen()`, `dlsym()`, or `ccall()` usage.  While this structure contains the ability to run arbitrary code on first load via `on_load_callback`, we caution that this should be used sparingly, as it is not expected that `ccall()` should result in large amounts of Julia code being run.  You may call `ccall()` from within the `on_load_callback` but only for the current library and its dependencies, and user should not call `wait()` on any tasks within the on load callback.
