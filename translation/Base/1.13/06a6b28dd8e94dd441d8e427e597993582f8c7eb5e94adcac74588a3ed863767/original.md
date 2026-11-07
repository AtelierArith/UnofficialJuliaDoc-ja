```julia
_unsafe_take!(io::IOBuffer)
```

This simply returns the raw resized `io.data`, with no checks to be sure that `io` is readable etcetera, and leaves `io` in an inconsistent state.  This should only be used internally for performance-critical `String` routines that immediately discard `io` afterwards, and it *assumes* that `io` is writable and seekable.

It might save an allocation compared to `take!` (if the compiler elides the Array allocation), as well as omits some checks.
