```julia
isexported(m::Module, s::Symbol) -> Bool
```

Returns whether a symbol is exported from a module.

See also: [`ispublic`](@ref), [`names`](@ref)

```jldoctest
julia> module Mod
           export foo
           public bar
       end
Mod

julia> Base.isexported(Mod, :foo)
true

julia> Base.isexported(Mod, :bar)
false

julia> Base.isexported(Mod, :baz)
false
```
