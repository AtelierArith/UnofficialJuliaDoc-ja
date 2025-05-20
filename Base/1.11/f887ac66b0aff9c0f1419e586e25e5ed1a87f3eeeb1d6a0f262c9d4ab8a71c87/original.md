```
ispublic(m::Module, s::Symbol) -> Bool
```

Returns whether a symbol is marked as public in a module.

Exported symbols are considered public.

!!! compat "Julia 1.11"
    This function and the notion of publicity were added in Julia 1.11.


See also: [`isexported`](@ref), [`names`](@ref)

```jldoctest
julia> module Mod
           export foo
           public bar
       end
Mod

julia> Base.ispublic(Mod, :foo)
true

julia> Base.ispublic(Mod, :bar)
true

julia> Base.ispublic(Mod, :baz)
false
```
