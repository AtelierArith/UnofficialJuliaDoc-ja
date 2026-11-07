```julia
capture_exception(ex, bt)::Exception
```

Returns an exception, possibly incorporating information from a backtrace `bt`. Defaults to returning [`CapturedException(ex, bt)`](@ref).

Used in [`asyncmap`](@ref) and [`asyncmap!`](@ref) to capture exceptions thrown during the user-supplied function call.
