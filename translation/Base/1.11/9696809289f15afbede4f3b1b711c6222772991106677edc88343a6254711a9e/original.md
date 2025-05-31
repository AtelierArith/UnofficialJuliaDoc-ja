```
load_path()
```

Return the fully expanded value of [`LOAD_PATH`](@ref) that is searched for projects and packages.

!!! note
    `load_path` may return a reference to a cached value so it is not safe to modify the returned vector.

