```julia
parentmodule(m::Module) -> Module
```

Get a module's enclosing `Module`. `Main` is its own parent.

See also: [`names`](@ref), [`nameof`](@ref), [`fullname`](@ref), [`@__MODULE__`](@ref).

# Examples

```jldoctest
julia> parentmodule(Main)
Main

julia> parentmodule(Base.Broadcast)
Base
```
