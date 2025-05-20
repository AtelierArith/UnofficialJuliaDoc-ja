```
getglobal(module::Module, name::Symbol, [order::Symbol=:monotonic])
```

Retrieve the value of the binding `name` from the module `module`. Optionally, an atomic ordering can be defined for the operation, otherwise it defaults to monotonic.

While accessing module bindings using [`getfield`](@ref) is still supported to maintain compatibility, using `getglobal` should always be preferred since `getglobal` allows for control over atomic ordering (`getfield` is always monotonic) and better signifies the code's intent both to the user as well as the compiler.

Most users should not have to call this function directly – The [`getproperty`](@ref Base.getproperty) function or corresponding syntax (i.e. `module.name`) should be preferred in all but few very specific use cases.

!!! compat "Julia 1.9"
    This function requires Julia 1.9 or later.


See also [`getproperty`](@ref Base.getproperty) and [`setglobal!`](@ref).

# Examples

```jldoctest
julia> a = 1
1

julia> module M
       a = 2
       end;

julia> getglobal(@__MODULE__, :a)
1

julia> getglobal(M, :a)
2
```
