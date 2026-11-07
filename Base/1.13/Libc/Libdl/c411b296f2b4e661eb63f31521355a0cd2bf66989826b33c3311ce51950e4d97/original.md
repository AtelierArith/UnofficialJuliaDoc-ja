```julia
BundledLazyLibraryPath(subpath)
```

Helper type for lazily constructed library paths within the Julia distribution. Constructs paths relative to Julia's private shared library directory.

Primarily used by Julia's standard library. For example:

```julia
const libgmp = LazyLibrary(BundledLazyLibraryPath("libgmp.so.10"))
```

!!! compat "Julia 1.11"
    `BundledLazyLibraryPath` was added in Julia 1.11.


See also [`LazyLibrary`](@ref), [`LazyLibraryPath`](@ref).
