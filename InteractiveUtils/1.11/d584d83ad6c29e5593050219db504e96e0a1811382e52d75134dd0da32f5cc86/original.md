```julia
@trace_dispatch
```

A macro to execute an expression and report methods that were compiled via dynamic dispatch, like the julia arg `--trace-dispatch=stderr` but specifically for a call.

!!! compat "Julia 1.12"
    This macro requires at least Julia 1.12

