```
Pkg.precompile(; strict::Bool=false, timing::Bool=false)
Pkg.precompile(pkg; strict::Bool=false, timing::Bool=false)
Pkg.precompile(pkgs; strict::Bool=false, timing::Bool=false)
```

Precompile all or specific dependencies of the project in parallel.

Set `timing=true` to show the duration of the precompilation of each dependency.

!!! note
    Errors will only throw when precompiling the top-level dependencies, given that not all manifest dependencies may be loaded by the top-level dependencies on the given system. This can be overridden to make errors in all dependencies throw by setting the kwarg `strict` to `true`


!!! note
    This method is called automatically after any Pkg action that changes the manifest. Any packages that have previously errored during precompilation won't be retried in auto mode until they have changed. To disable automatic precompilation set `ENV["JULIA_PKG_PRECOMPILE_AUTO"]=0`. To manually control the number of tasks used set `ENV["JULIA_NUM_PRECOMPILE_TASKS"]`.


!!! compat "Julia 1.8"
    Specifying packages to precompile requires at least Julia 1.8.


!!! compat "Julia 1.9"
    Timing mode requires at least Julia 1.9.


# Examples

```julia
Pkg.precompile()
Pkg.precompile("Foo")
Pkg.precompile(["Foo", "Bar"])
```
