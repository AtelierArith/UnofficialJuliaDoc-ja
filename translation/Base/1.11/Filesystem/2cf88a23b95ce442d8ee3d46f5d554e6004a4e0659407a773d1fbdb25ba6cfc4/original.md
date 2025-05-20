```
contractuser(path::AbstractString) -> AbstractString
```

On Unix systems, if the path starts with `homedir()`, replace it with a tilde character.

See also: [`expanduser`](@ref).
