```julia
pipeline(command, redir::Pair{<:Integer, <:Redirectable})
```

Redirect fd number `redir.first` of `command` to or from the given `redir.second`, which can be an I/O stream, a filename, or a file descriptor. This method is primarily used to pass additional fds beyond the standard ios that are not supported by the keyword argument interface.

!!! compat "Julia 1.13"
    This method requires Julia 1.13 or later.

