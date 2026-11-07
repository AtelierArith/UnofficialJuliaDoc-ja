```julia
Core.finalizer(f, o)
```

This builtin is an implementation detail of [`Base.finalizer`](@ref) and end-users should use the latter instead.

# Differences from `Base.finalizer`

The interface of `Core.finalizer` is essentially the same as `Base.finalizer`, but there are a number of small differences. They are documented here for completeness only and (unlike `Base.finalizer`) have no stability guarantees.

The current differences are:

  * `Core.finalizer` does not check for mutability of `o`. Attempting to register a finalizer for an immutable object is undefined behavior.
  * The value `f` must be a Julia object. `Core.finalizer` does not support a raw C function pointer.
  * `Core.finalizer` returns `nothing` rather than `o`.
