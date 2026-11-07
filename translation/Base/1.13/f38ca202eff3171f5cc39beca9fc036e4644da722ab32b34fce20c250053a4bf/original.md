```julia
setgid(original_command::Cmd, gid) -> command::Cmd
```

Set the group ID (GID) of the `command`. On Unix systems, this allows the command to run as a different group. Passing `gid = nothing` removes any previously set GID.

This function is only supported on Unix-based systems (Linux, macOS, etc.). Requires appropriate permissions to set GID.

!!! compat "Julia 1.13"
    This function requires at least Julia 1.13.


# Examples

```julia
julia> run(setgid(`id -g`, 1000));
1000
```
