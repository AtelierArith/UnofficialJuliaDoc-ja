```julia
redirect_stdio(;stdin=stdin, stderr=stderr, stdout=stdout)
```

Redirect a subset of the streams `stdin`, `stderr`, `stdout`. Each argument must be an `IOStream`, `TTY`, [`Pipe`](@ref), socket, or `devnull`.

!!! compat "Julia 1.7"
    `redirect_stdio` requires Julia 1.7 or later.

