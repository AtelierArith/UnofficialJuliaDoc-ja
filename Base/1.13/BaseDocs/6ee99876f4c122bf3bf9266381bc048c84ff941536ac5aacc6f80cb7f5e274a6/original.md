```julia
isdefinedglobal(m::Module, s::Symbol, [allow_import::Bool=true, [order::Symbol=:unordered]])
```

Tests whether a global variable `s` is defined in module `m` (in the current world age). A variable is considered defined if and only if a value may be read from this global variable and an access will not throw. This includes both constants and global variables that have a value set.

If `allow_import` is `false`, the global variable must be defined inside `m` and may not be imported from another module.

!!! compat "Julia 1.12"
    This function requires Julia 1.12 or later.


See also [`@isdefined`](@ref).

# Examples

```jldoctest
julia> isdefinedglobal(Base, :sum)
true

julia> isdefinedglobal(Base, :NonExistentMethod)
false

julia> isdefinedglobal(Base, :sum, false)
true

julia> isdefinedglobal(Main, :sum, false)
false
```
