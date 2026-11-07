```julia
isbindingresolved(m::Module, s::Symbol) -> Bool
```

Returns whether the binding of a symbol in a module is resolved.

See also: [`isexported`](@ref), [`ispublic`](@ref), [`isdeprecated`](@ref)

```jldoctest
julia> module Mod
           foo() = 17
       end
Mod

julia> Base.isbindingresolved(Mod, :foo)
true
```

!!! warning
    This function is deprecated. The concept of binding "resolvedness" was removed in Julia 1.12. The function now always returns `true`.

