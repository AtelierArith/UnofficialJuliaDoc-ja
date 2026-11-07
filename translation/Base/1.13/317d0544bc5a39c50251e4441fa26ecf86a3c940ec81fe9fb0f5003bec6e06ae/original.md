```julia
run(command, args...; wait::Bool = true)
```

Run a command object, constructed with backticks (see the [Running External Programs](@ref) section in the manual). Throws an error if anything goes wrong, including the process exiting with a non-zero status (when `wait` is true).

The `args...` allow you to pass through file descriptors to the command, and are ordered like regular unix file descriptors (eg `stdin, stdout, stderr, FD(3), FD(4)...`).

If `wait` is false, the process runs asynchronously. You can later [`wait`](@ref) for it and check its exit status by calling `success` on the returned process object. If the `command` spawns only a single process, a `Process` object is returned and the exit code can be retrieved via the `exitcode` field; see [`wait`](@ref) for more details.

When `wait` is false, the process' I/O streams are directed to `devnull`. When `wait` is true, I/O streams are shared with the parent process. Use [`pipeline`](@ref) to control I/O redirection.

See also: [`Cmd`](@ref).
