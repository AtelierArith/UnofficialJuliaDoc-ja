```
Experimental.show_error_hints(io, ex, args...)
```

Invoke all handlers from [`Experimental.register_error_hint`](@ref) for the particular exception type `typeof(ex)`. `args` must contain any other arguments expected by the handler for that type.

!!! compat "Julia 1.5"
    Custom error hints are available as of Julia 1.5.


!!! warning
    This interface is experimental and subject to change or removal without notice.

