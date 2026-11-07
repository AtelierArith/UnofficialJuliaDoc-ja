```julia
Pkg.autoprecompilation_enabled(state::Bool)
```

Enable or disable automatic precompilation for Pkg operations.

When `state` is `true` (default), Pkg operations that modify the project environment will automatically trigger precompilation of affected packages. When `state` is `false`, automatic precompilation is disabled and packages will only be precompiled when explicitly requested via [`Pkg.precompile`](@ref).

This setting affects the global state and persists across Pkg operations in the same Julia session. It can be used in combination with [`Pkg.precompile`](@ref) do-syntax for more fine-grained control over when precompilation occurs.

!!! compat "Julia 1.13"
    This function requires at least Julia 1.13.


# Examples

```julia
# Disable automatic precompilation
Pkg.autoprecompilation_enabled(false)
Pkg.add("Example")  # Will not trigger auto-precompilation
Pkg.precompile()    # Manual precompilation

# Re-enable automatic precompilation
Pkg.autoprecompilation_enabled(true)
Pkg.add("AnotherPackage")  # Will trigger auto-precompilation
```

See also [`Pkg.precompile`](@ref).
