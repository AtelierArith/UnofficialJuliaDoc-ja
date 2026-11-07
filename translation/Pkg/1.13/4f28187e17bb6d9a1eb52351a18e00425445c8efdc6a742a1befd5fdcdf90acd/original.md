```julia
Pkg.precompile(; strict::Bool=false, timing::Bool=false, workspace::Bool=false)
Pkg.precompile(pkg; strict::Bool=false, timing::Bool=false, workspace::Bool=false)
Pkg.precompile(pkgs; strict::Bool=false, timing::Bool=false, workspace::Bool=false)
Pkg.precompile(f, args...; kwargs...)
```

Precompile all or specific dependencies of the project in parallel.

Set `timing=true` to show the duration of the precompilation of each dependency.

Set `workspace=true` to precompile every project in the workspace rather than only the active one.

To delay autoprecompilation of multiple Pkg actions until the end use. This may be most efficient while manipulating the environment in various ways.

```julia
Pkg.precompile() do
    # Pkg actions here
end
```

!!! note
    Errors will only throw when precompiling the top-level dependencies, given that not all manifest dependencies may be loaded by the top-level dependencies on the given system. This can be overridden to make errors in all dependencies throw by setting the kwarg `strict` to `true`


!!! note
    This method is called automatically after any Pkg action that changes the manifest. Any packages that have previously errored during precompilation won't be retried in auto mode until they have changed. To disable automatic precompilation set `ENV["JULIA_PKG_PRECOMPILE_AUTO"]=0`. To manually control the number of tasks used set `ENV["JULIA_NUM_PRECOMPILE_TASKS"]`.


!!! compat "Julia 1.8"
    Specifying packages to precompile requires at least Julia 1.8.


!!! compat "Julia 1.9"
    Timing mode requires at least Julia 1.9.


!!! compat "Julia 1.13"
    The `Pkg.precompile(f, args...; kwargs...)` do-block syntax requires at least Julia 1.13.


# Examples

```julia
Pkg.precompile()
Pkg.precompile("Foo")
Pkg.precompile(["Foo", "Bar"])
```
