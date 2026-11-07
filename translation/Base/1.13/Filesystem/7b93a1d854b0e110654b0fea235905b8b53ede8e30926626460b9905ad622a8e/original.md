```julia
iswritable(path::String)
```

Return `true` if the access permissions for the given `path` permitted writing by the current user.

!!! note
    This permission may change before the user calls `open`, so it is recommended to just call `open` alone and handle the error if that fails, rather than calling `iswritable` first.


!!! note
    Currently this function does not correctly interrogate filesystem ACLs on Windows, therefore it can return wrong results.


!!! compat "Julia 1.11"
    This function requires at least Julia 1.11.


See also [`ispath`](@ref), [`isexecutable`](@ref), [`isreadable`](@ref).
