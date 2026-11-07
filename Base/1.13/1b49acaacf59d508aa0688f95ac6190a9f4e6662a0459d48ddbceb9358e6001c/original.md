```julia
redirect_stdio(f; stdin=nothing, stderr=nothing, stdout=nothing)
```

Redirect a subset of the streams `stdin`, `stderr`, `stdout`, call `f()` and restore each stream.

Possible values for each stream are:

  * `nothing` indicating the stream should not be redirected.
  * `path::AbstractString` redirecting the stream to the file at `path`.
  * `io` an `IOStream`, `TTY`, [`Pipe`](@ref), socket, or `devnull`.

# Examples

```julia-repl
julia> redirect_stdio(stdout="stdout.txt", stderr="stderr.txt") do
           print("hello stdout")
           print(stderr, "hello stderr")
       end

julia> read("stdout.txt", String)
"hello stdout"

julia> read("stderr.txt", String)
"hello stderr"
```

# Edge cases

It is possible to pass the same argument to `stdout` and `stderr`:

```julia-repl
julia> redirect_stdio(stdout="log.txt", stderr="log.txt", stdin=devnull) do
    ...
end
```

However it is not supported to pass two distinct descriptors of the same file.

```julia-repl
julia> io1 = open("same/path", "w")

julia> io2 = open("same/path", "w")

julia> redirect_stdio(f, stdout=io1, stderr=io2) # not supported
```

Also the `stdin` argument may not be the same descriptor as `stdout` or `stderr`.

```julia-repl
julia> io = open(...)

julia> redirect_stdio(f, stdout=io, stdin=io) # not supported
```

!!! compat "Julia 1.7"
    `redirect_stdio` requires Julia 1.7 or later.

