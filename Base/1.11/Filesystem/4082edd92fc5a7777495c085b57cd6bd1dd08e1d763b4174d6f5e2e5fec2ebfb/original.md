```
isexecutable(path::String)
```

Return `true` if the given `path` has executable permissions.

!!! note
    This permission may change before the user executes `path`, so it is recommended to execute the file and handle the error if that fails, rather than calling `isexecutable` first.


!!! note
    Prior to Julia 1.6, this did not correctly interrogate filesystem ACLs on Windows, therefore it would return `true` for any file.  From Julia 1.6 on, it correctly determines whether the file is marked as executable or not.


See also [`ispath`](@ref), [`isreadable`](@ref), [`iswritable`](@ref).
