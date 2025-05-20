```
Sys.username() -> String
```

Return the username for the current user. If the username cannot be determined or is empty, this function throws an error.

To retrieve a username that is overridable via an environment variable, e.g., `USER`, consider using

```julia
user = get(Sys.username, ENV, "USER")
```

!!! compat "Julia 1.11"
    This function requires at least Julia 1.11.


See also [`homedir`](@ref).
