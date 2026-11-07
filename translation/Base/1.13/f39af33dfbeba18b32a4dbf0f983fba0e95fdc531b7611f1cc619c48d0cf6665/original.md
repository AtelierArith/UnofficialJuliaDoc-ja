```julia
setuid(original_command::Cmd, uid) -> command::Cmd
```

Set the user ID (UID) of the `command`. On Unix systems, this allows the command to run as a different user. Passing `uid = nothing` removes any previously set UID.

This function is only supported on Unix-based systems (Linux, macOS, etc.). Requires appropriate permissions to set UID.

!!! compat "Julia 1.13"
    This function requires at least Julia 1.13.


# Examples

```julia
julia> run(setuid(`id -u`, 1000));
1000
```
