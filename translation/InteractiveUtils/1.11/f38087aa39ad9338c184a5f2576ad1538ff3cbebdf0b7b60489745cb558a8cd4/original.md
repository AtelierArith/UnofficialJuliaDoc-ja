```julia
has_system_clipboard() -> Bool
```

Return `true` if the operating system has a clipboard mechanism available. On macOS and Windows this is always `true`. On Linux and FreeBSD, it checks for the presence of `xclip`, `xsel`, or `wl-copy` (from `wl-clipboard`). On other systems, returns `false`.

!!! compat "Julia 1.14"
    This function requires Julia 1.14 or later.


See also [`clipboard`](@ref).
