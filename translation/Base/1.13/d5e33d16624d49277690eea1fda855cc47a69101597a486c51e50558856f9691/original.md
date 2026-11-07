```julia
names(x::Module; all::Bool=false, imported::Bool=false, usings::Bool=false, world::UInt=Base.tls_world_age())::Vector{Symbol}
```

Get a vector of the public names of a `Module`, excluding deprecated names. If `all` is true, then the list also includes non-public names defined in the module, deprecated names, and compiler-generated names. If `imported` is true, then names explicitly imported from other modules are also included. If `usings` is true, then names explicitly or implicitly imported via `using` are also included. Names are returned in sorted order.

As a special case, all names defined in `Main` are considered "public", since it is not idiomatic to explicitly mark names from `Main` as public.

The `world` argument controls the world age used to look up binding partitions, defaulting to the current task's world age. Pass `world=Base.get_world_counter()` to include names from the latest world.

!!! note
    `sym ∈ names(SomeModule)` does *not* imply `isdefined(SomeModule, sym)`. `names` may return symbols marked with `public` or `export`, even if they are not defined in the module.


!!! warning
    `names` may return duplicate names. The duplication happens, e.g. if an `import`ed name conflicts with an already existing identifier.


!!! compat "Julia 1.12"
    The `usings` argument requires Julia 1.12 or later.


See also: [`Base.isexported`](@ref), [`Base.ispublic`](@ref), [`Base.@locals`](@ref), [`@__MODULE__`](@ref).
