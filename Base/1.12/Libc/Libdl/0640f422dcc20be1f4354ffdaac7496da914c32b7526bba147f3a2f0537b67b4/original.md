```julia
LazyLibraryPath
```

Helper type for lazily constructed library paths for use with `LazyLibrary`. Arguments are passed to `joinpath()`.  Arguments must be able to have `string()` called on them.

```julia
libfoo = LazyLibrary(LazyLibraryPath(prefix, "lib/libfoo.so.1.2.3"))
```
