```julia
@invokelatest f(args...; kwargs...)
```

Provides a convenient way to call [`invokelatest`](@ref). `@invokelatest f(args...; kwargs...)` will simply be expanded into `Base.invokelatest(f, args...; kwargs...)`.

It also supports the following syntax:

  * `@invokelatest x.f` expands to `Base.invokelatest(getproperty, x, :f)`
  * `@invokelatest x.f = v` expands to `Base.invokelatest(setproperty!, x, :f, v)`
  * `@invokelatest xs[i]` expands to `Base.invokelatest(getindex, xs, i)`
  * `@invokelatest xs[i] = v` expands to `Base.invokelatest(setindex!, xs, v, i)`

!!! note
    If `f` is a global, it will be resolved consistently in the (latest) world as the call target. However, all other arguments (as well as `f` itself if it is not a literal global) will be evaluated in the current world age.


!!! compat "Julia 1.7"
    This macro requires Julia 1.7 or later.


!!! compat "Julia 1.9"
    Prior to Julia 1.9, this macro was not exported, and was called as `Base.@invokelatest`.


!!! compat "Julia 1.10"
    The additional `x.f` and `xs[i]` syntax requires Julia 1.10.

