```julia
addenv(command::Cmd, env...; inherit::Bool = true)
```

Merge new environment mappings into the given [`Cmd`](@ref) object, returning a new `Cmd` object. Duplicate keys are replaced.  If `command` does not contain any environment values set already, it inherits the current environment at time of `addenv()` call if `inherit` is `true`. Keys with value `nothing` are deleted from the env.

See also [`Cmd`](@ref), [`setenv`](@ref), [`ENV`](@ref).

!!! compat "Julia 1.6"
    This function requires Julia 1.6 or later.

