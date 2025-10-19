```julia
operm(path)
operm(path_elements...)
operm(stat_struct)
```

Like [`uperm`](@ref) but gets the permissions for people who neither own the file nor are a member of the group owning the file.

See also [`gperm`](@ref).
