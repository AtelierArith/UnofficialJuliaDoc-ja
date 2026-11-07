```julia
LazyLibraryPath(path_pieces...)
```

Helper type for lazily constructed library paths for use with [`LazyLibrary`](@ref). Path pieces are stored unevaluated and joined with `joinpath()` when the library is first accessed. Arguments must be able to have `string()` called on them.

# Example

```julia
const mylib = LazyLibrary(LazyLibraryPath(artifact_dir, "lib", "libmylib.so.1.2.3"))
```

!!! compat "Julia 1.11"
    `LazyLibraryPath` was added in Julia 1.11.


See also [`LazyLibrary`](@ref), [`BundledLazyLibraryPath`](@ref).
