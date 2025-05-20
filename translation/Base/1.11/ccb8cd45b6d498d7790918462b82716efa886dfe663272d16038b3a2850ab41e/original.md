```
names(x::Module; all::Bool = false, imported::Bool = false)
```

Get a vector of the public names of a `Module`, excluding deprecated names. If `all` is true, then the list also includes non-public names defined in the module, deprecated names, and compiler-generated names. If `imported` is true, then names explicitly imported from other modules are also included. Names are returned in sorted order.

As a special case, all names defined in `Main` are considered "public", since it is not idiomatic to explicitly mark names from `Main` as public.

!!! note
    `sym ∈ names(SomeModule)` does *not* imply `isdefined(SomeModule, sym)`. `names` will return symbols marked with `public` or `export`, even if they are not defined in the module.


See also: [`Base.isexported`](@ref), [`Base.ispublic`](@ref), [`Base.@locals`](@ref), [`@__MODULE__`](@ref).
